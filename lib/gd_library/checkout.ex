defmodule GDLibrary.Checkout do
  @moduledoc """
  The Checkout context.
  """

  import Ecto.Changeset

  alias GDLibrary.Repo
  alias GDLibrary.Inventory

  alias GDLibrary.Schemas.{
    BookRequest
  }

  def create_book_request!(attrs) do
    {:ok, book_request} = create_book_request(attrs)
    book_request
  end

  def create_book_request(attrs) do
    %BookRequest{}
    |> BookRequest.changeset(attrs)
    |> Repo.insert()
  end

  def request_book(%{"title" => title, "email" => email}) do
    case Inventory.search_books_by_title(title) do
      [book] ->
        with {:ok, book_request} <-
               create_book_request(%{requested_book_id: book.id, email: email}) do
          try_to_hold(book_request)
        end

      [] ->
        {:error, "No results."}

      books ->
        {:error,
         "Too many results (#{length(books)})! We couldn't determine which book you're looking for."}
    end
  end

  def request_book(_) do
    {:error, "Must include `email` and `title` keys to request a book"}
  end

  def undo_book_request(book_request_id) do
    book_request_id
    |> Inventory.get_book_request!()
    |> undo_request_changeset()
    |> Repo.delete()
  end

  defp try_to_hold(%BookRequest{requested_book_id: requested_book_id} = book_request) do
    case Inventory.get_available_book_copy_id(requested_book_id) do
      nil ->
        {:ok, book_request}

      available_book_copy_id ->
        book_request
        |> hold_changeset(%{
          held_book_copy_id: available_book_copy_id,
          held_at: NaiveDateTime.utc_now()
        })
        |> Repo.update()
    end
  end

  defp hold_changeset(book_request, attrs) do
    book_request
    |> cast(attrs, [
      :held_book_copy_id,
      :held_at
    ])
    |> validate_required([:held_book_copy_id, :held_at])
  end

  defp undo_request_changeset(book_request) do
    book_request
    |> Ecto.Changeset.change()
    |> validate_still_in_inventory()
  end

  defp validate_still_in_inventory(changeset) do
    case get_field(changeset, :checked_out_at) do
      nil ->
        changeset

      _checked_out_at ->
        changeset
        |> add_error(:checked_out_at, "is already set")
    end
  end
end
