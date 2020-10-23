defmodule GDLibraryWeb.BookRequestControllerTest do
  use GDLibraryWeb.ConnCase

  alias GDLibrary.{Inventory, Checkout}

  def fixture(:author, %{full_name: _full_name} = attrs) do
    attrs
    |> Inventory.create_author!()
  end

  def fixture(:book, %{title: _full_name, author_id: _author_id} = attrs) do
    attrs
    |> Inventory.create_book!()
  end

  def fixture(:book_copy, %{book_id: _book_id} = attrs) do
    attrs
    |> Inventory.create_book_copy!()
  end

  def fixture(:book_request, %{email: _email, requested_book_id: _book_id} = attrs) do
    attrs
    |> Checkout.create_book_request!()
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:setup_inventory]

    test "lists all book_requests", %{conn: conn} do
      conn = get(conn, Routes.book_request_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create book_request" do
    setup [:setup_inventory]

    test "renders response when data is valid", %{conn: conn, books: [book | _rest]} do
      conn =
        post(conn, Routes.book_request_path(conn, :create),
          email: "reader@test.com",
          title: book.title
        )

      [book_request] = Inventory.get_requests_for_book(book.id)

      expected_book_id = book.id
      expected_available = not is_nil(book_request.held_book_copy_id)
      expected_book_title = book.title
      expected_timestamp = book_request.inserted_at

      assert %{
               "id" => ^expected_book_id,
               "available" => ^expected_available,
               "title" => ^expected_book_title,
               "timestamp" => ^expected_timestamp
             } = json_response(conn, 201)["data"]

      conn = get(conn, Routes.book_request_path(conn, :show, book_request.id))

      assert %{
               "id" => ^expected_book_id,
               "available" => ^expected_available,
               "title" => ^expected_book_title,
               "timestamp" => ^expected_timestamp
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, books: [book | _rest]} do
      conn = post(conn, Routes.book_request_path(conn, :create), title: book.title)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete book_request" do
    setup [:setup_inventory]

    test "deletes chosen book_request when not checked out", %{conn: conn, books: [book | _rest]} do
      {:ok, book_request} =
        Checkout.request_book(%{email: "nonreader@test.com"}, title: book.title)

      conn = delete(conn, Routes.book_request_path(conn, :delete, book_request.id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.book_request_path(conn, :show, book_request.id))
      end
    end
  end

  defp setup_inventory(_) do
    # 3 books per author
    authors =
      1..3
      |> Enum.map(fn n ->
        fixture(:author, %{full_name: "Jane Doe #{n}"})
      end)

    # 2 books per author
    books =
      authors
      |> Enum.flat_map(fn %{id: author_id} ->
        1..2
        |> Enum.map(fn n ->
          fixture(:book, %{title: "Direct Transfers #{n}-#{author_id}", author_id: author_id})
        end)
      end)

    # 5 copies of each book
    book_copies =
      books
      |> Enum.map(fn %{id: book_id} ->
        1..5
        |> Enum.map(fn _n ->
          fixture(:book_copy, %{book_id: book_id})
        end)
      end)

    %{
      authors: authors,
      books: books,
      book_copies: book_copies
    }
  end
end
