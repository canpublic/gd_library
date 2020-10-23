defmodule GDLibrary.Schemas.Author do
  use Ecto.Schema
  import Ecto.Changeset

  schema "authors" do
    field :full_name, :string

    timestamps()
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:full_name])
    |> validate_required([:full_name])
  end
end
