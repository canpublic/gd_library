defmodule GDLibrary.Repo.Migrations.CreateBooks do
  use Ecto.Migration

  def change do
    create table(:books) do
      add :title, :text, null: false
      add :author_id, references(:authors, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:books, [:title, :author_id])
  end
end
