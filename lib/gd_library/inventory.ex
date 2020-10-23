defmodule GDLibrary.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query
  alias GDLibrary.Repo

  alias GDLibrary.Schemas.{
    Author,
    Book,
    BookCopy,
    BookRequest
  }

  def create_author!(attrs) do
    %Author{}
    |> Author.changeset(attrs)
    |> Repo.insert!()
  end

  def create_book!(attrs) do
    %Book{}
    |> Book.changeset(attrs)
    |> Repo.insert!()
  end

  def create_book_copy!(attrs) do
    %BookCopy{}
    |> BookCopy.changeset(attrs)
    |> Repo.insert!()
  end

  def list_book_requests() do
    from(request in BookRequest,
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
  end

  def search_books_by_title(title) do
    from(book in Book,
      order_by: [desc: :inserted_at],
      where: book.title == ^title
    )
    |> Repo.all()
  end

  def get_book_request!(id) do
    Repo.get!(BookRequest, id)
  end

  def get_requests_for_book(book_id) when is_integer(book_id) do
    from(request in BookRequest,
      where: request.requested_book_id == ^book_id
    )
    |> Repo.all()
  end

  def get_available_book_copy_id(book_id) when is_integer(book_id) do
    unavailable_book_copy_query =
      from(request in BookRequest,
        select: request.held_book_copy_id,
        where:
          is_nil(request.returned_at) and not is_nil(request.held_book_copy_id) and
            request.requested_book_id == ^book_id
      )

    from(copy in BookCopy,
      select: copy.id,
      where: copy.book_id == ^book_id,
      where: copy.id not in subquery(unavailable_book_copy_query),
      limit: 1
    )
    |> Repo.one()
  end
end
