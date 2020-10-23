defmodule GDLibrary.Repo.Migrations.CreateBookCopies do
  use Ecto.Migration

  def change do
    create table(:book_copies) do
      add :book_id, references(:books, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
