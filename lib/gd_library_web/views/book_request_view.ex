defmodule GDLibraryWeb.BookRequestView do
  use GDLibraryWeb, :view
  alias GDLibraryWeb.BookRequestView
  alias GDLibrary.Repo

  def render("index.json", %{book_requests: book_requests}) do
    render_many(preload(book_requests), BookRequestView, "book_request.json")
  end

  def render("show.json", %{book_request: book_request}) do
    render_one(preload(book_request), BookRequestView, "book_request.json")
  end

  def render("book_request.json", %{book_request: book_request}) do
    %{
      id: book_request.requested_book_id,
      title: book_request.requested_book.title,
      available: not is_nil(book_request.held_book_copy_id),
      timestamp: NaiveDateTime.to_iso8601(book_request.inserted_at)
    }
  end

  defp preload(book_request_or_requests) do
    book_request_or_requests
    |> Repo.preload(:requested_book)
  end
end
