defmodule GDLibraryWeb.BookRequestControllerTest do
  use GDLibraryWeb.ConnCase

  alias GDLibrary.{Inventory, Checkout}
  alias GDLibrary.Repo

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:setup_inventory]

    test "lists all book_requests", %{conn: conn, books: books} do
      # request five different books
      books
      |> Enum.slice(0..4)
      |> Enum.map(fn book ->
        success_conn =
          post(conn, "/request", %{
            email: "reader#{book.id}@test.com",
            title: book.title
          })

        assert true == json_response(success_conn, 201)["available"]
      end)

      conn = get(conn, Routes.book_request_path(conn, :index))
      assert 5 == length(json_response(conn, 200))
    end
  end

  describe "create book_request" do
    setup [:setup_inventory]

    test "renders response when data is valid", %{conn: conn, books: [book | _rest]} do
      conn =
        post(conn, "/request", %{
          email: "reader@test.com",
          title: book.title
        })

      [book_request] = Inventory.get_requests_for_book(book.id)

      expected_book_id = book.id
      expected_available = not is_nil(book_request.held_book_copy_id)
      expected_book_title = book.title
      expected_timestamp = NaiveDateTime.to_iso8601(book_request.inserted_at)
      expected_book_request_id = book_request.id

      assert %{
               "id" => ^expected_book_id,
               "available" => ^expected_available,
               "title" => ^expected_book_title,
               "timestamp" => ^expected_timestamp,
               "book_request_id" => ^expected_book_request_id
             } = json_response(conn, 201)

      conn = get(conn, "/request/#{book_request.id}")

      assert %{
               "id" => ^expected_book_id,
               "available" => ^expected_available,
               "title" => ^expected_book_title,
               "timestamp" => ^expected_timestamp,
               "book_request_id" => ^expected_book_request_id
             } = json_response(conn, 200)
    end

    test "renders errors when user tries to request same book twice", %{
      conn: conn,
      books: [book | _rest]
    } do
      post(conn, "/request", %{
        email: "crazyreader@test.com",
        title: book.title
      })

      conn =
        post(conn, "/request", %{
          email: "crazyreader@test.com",
          title: book.title
        })

      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders book unavailable when all copies have been held", %{
      conn: conn,
      books: [book | _rest]
    } do
      %{copies: copies} = Repo.preload(book, :copies)

      # request all the copies!
      copies
      |> Enum.map(fn copy ->
        success_conn =
          post(conn, "/request", %{
            email: "reader#{copy.id}@test.com",
            title: book.title
          })

        assert true == json_response(success_conn, 201)["available"]
      end)

      bad_conn =
        post(conn, "/request", %{
          email: "copycat@test.com",
          title: book.title
        })

      assert false == json_response(bad_conn, 201)["available"]
    end

    test "renders errors when title isn't specific enough", %{conn: conn} do
      conn = post(conn, "/request", %{email: "toovague@test.com", title: "Cash Transfers"})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when title doesn't exist at all", %{conn: conn} do
      conn = post(conn, "/request", %{email: "totallywrong@test.com", title: "Bad Title"})
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "renders errors when payload itself is invalid", %{conn: conn, books: [book | _rest]} do
      conn = post(conn, "/request", %{title: book.title})
      assert json_response(conn, 422)["errors"] != %{}

      conn = post(conn, "/request", %{email: "email@test.com"})
      assert json_response(conn, 422)["errors"] != %{}

      conn = post(conn, "/request", %{title: book.title, email: "invalidemail"})
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete book_request" do
    setup [:setup_inventory]

    test "deletes chosen book_request when not checked out", %{conn: conn, books: [book | _rest]} do
      {:ok, book_request} =
        Checkout.request_book(%{"email" => "nonreader@test.com", "title" => book.title})

      conn = delete(conn, "/request/#{book_request.id}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, "/request/#{book_request.id}")
      end
    end
  end

  defp setup_inventory(_) do
    GDLibrary.Seeds.insert_all!()
  end
end
