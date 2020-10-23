defmodule GDLibrary.Schemas.BookCopy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "book_copies" do
    belongs_to :book, GDLibrary.Schemas.Book
    has_many :holds, GDLibrary.Schemas.BookRequest, foreign_key: :held_book_copy_id

    timestamps()
  end

  @doc false
  def changeset(book_copy, attrs) do
    book_copy
    |> cast(attrs, [:book_id])
    |> validate_required([:book_id])
  end
end
