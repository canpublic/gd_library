defmodule GDLibrary.Schemas.Book do
  use Ecto.Schema
  import Ecto.Changeset

  schema "books" do
    field :title, :string
    belongs_to :author, GDLibrary.Schemas.Author
    has_many :copies, GDLibrary.Schemas.BookCopy
    has_many :requests, GDLibrary.Schemas.BookRequest, foreign_key: :requested_book_id

    timestamps()
  end

  @doc false
  def changeset(book, attrs) do
    book
    |> cast(attrs, [:title, :author_id])
    |> validate_required([:title, :author_id])
  end
end
