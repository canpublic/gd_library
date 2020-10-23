defmodule GDLibrary.Schemas.BookRequest do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_email ~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i

  schema "book_requests" do
    field(:email, :string)
    belongs_to :requested_book, GDLibrary.Schemas.Book
    belongs_to :held_book_copy, GDLibrary.Schemas.BookCopy

    # field `requested_at` is just implicitly built-in `inserted_at`
    field :held_at, :naive_datetime
    field :checked_out_at, :naive_datetime
    field :due_back_at, :naive_datetime
    field :returned_at, :naive_datetime

    timestamps()
  end

  @doc false
  def changeset(book_request, attrs) do
    book_request
    |> cast(attrs, [
      :email,
      :requested_book_id,
      :held_book_copy_id,
      :held_at,
      :checked_out_at,
      :due_back_at,
      :returned_at
    ])
    |> validate_required([:email, :requested_book_id])
    |> validate_format(:email, @valid_email)
    |> unique_constraint([:email, :requested_book_id],
      name: :book_requests_email_requested_book_id_index,
      message: "can't be used to request the same book twice"
    )
  end
end
