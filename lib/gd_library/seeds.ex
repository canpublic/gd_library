defmodule GDLibrary.Seeds do
  alias GDLibrary.Repo
  alias GDLibrary.Inventory

  alias GDLibrary.Schemas.{
    Author,
    Book,
    BookCopy
  }

  def insert_all!() do
    # 3 books per author
    authors =
      1..3
      |> Enum.map(fn n ->
        Inventory.create_author!(%{full_name: "Jane Doe #{n}"})
      end)

    # 2 books per author
    books =
      authors
      |> Enum.flat_map(fn %{id: author_id} ->
        1..2
        |> Enum.map(fn n ->
          Inventory.create_book!(%{
            title: "Cash Transfers #{n}-#{author_id}",
            author_id: author_id
          })
        end)
      end)

    # 5 copies of each book
    book_copies =
      books
      |> Enum.map(fn %{id: book_id} ->
        1..5
        |> Enum.map(fn _n ->
          Inventory.create_book_copy!(%{book_id: book_id})
        end)
      end)

    %{
      authors: authors,
      books: books,
      book_copies: book_copies
    }
  end

  def delete_all!() do
    [
      Author,
      Book,
      BookCopy
    ]
    |> Enum.each(fn schema ->
      Repo.delete_all(schema)
    end)
  end
end
