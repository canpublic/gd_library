defmodule GDLibrary.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :full_name, :text, null: false

      timestamps()
    end
  end
end
