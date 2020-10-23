defmodule GDLibraryWeb.BookRequestController do
  use GDLibraryWeb, :controller

  alias GDLibrary.{
    Inventory,
    Checkout
  }

  alias GDLibraryWeb.BookRequestView

  action_fallback GDLibraryWeb.FallbackController

  def index(conn, _params) do
    book_requests = Inventory.list_book_requests()

    conn
    |> put_view(BookRequestView)
    |> render("index.json", book_requests: book_requests)
  end

  def show(conn, %{"id" => id}) do
    book_request = Inventory.get_book_request!(id)

    conn
    |> put_view(BookRequestView)
    |> render("show.json", book_request: book_request)
  end

  def create(conn, params) do
    with {:ok, book_request} <- Checkout.request_book(params) do
      conn
      |> put_status(:created)
      |> put_view(BookRequestView)
      |> put_resp_header("location", Routes.book_request_path(conn, :show, book_request.id))
      |> render("show.json", book_request: book_request)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, _book_request} <- Checkout.undo_book_request(id) do
      send_resp(conn, :no_content, "")
    end
  end
end
