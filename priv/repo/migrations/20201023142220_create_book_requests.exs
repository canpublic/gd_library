defmodule GDLibrary.Repo.Migrations.CreateBookRequests do
  use Ecto.Migration

  def change do
    create table(:book_requests) do
      add :email, :text, null: false
      add :requested_book_id, references(:books, on_delete: :delete_all), null: false
      add :held_book_copy_id, references(:book_copies, on_delete: :delete_all)
      add :held_at, :naive_datetime
      add :checked_out_at, :naive_datetime
      add :due_back_at, :naive_datetime
      add :returned_at, :naive_datetime

      timestamps()
    end

    # prevent same "user" from requesting or checking out the same book more than one time
    create unique_index(:book_requests, [:email, :requested_book_id])
    create unique_index(:book_requests, [:email, :held_book_copy_id])

    create constraint(:book_requests, "held_at_must_be_before_checked_out_at",
             check: "held_at <= checked_out_at"
           )

    create constraint(:book_requests, "checked_out_at_must_be_before_due_back_at",
             check: "checked_out_at <= due_back_at"
           )

    create constraint(:book_requests, "held_book_copy_id_and_held_at_must_stay_in_sync",
             check:
               "(held_book_copy_id IS NULL AND held_at IS NULL) OR (held_book_copy_id IS NOT NULL AND held_at IS NOT NULL)"
           )

    create constraint(:book_requests, "checked_out_at_and_due_back_at_must_stay_in_sync",
             check:
               "(checked_out_at IS NULL AND due_back_at IS NULL) OR (checked_out_at IS NOT NULL AND due_back_at IS NOT NULL)"
           )

    create constraint(:book_requests, "checked_out_at_must_be_present_to_set_returned_at",
             check:
               "(returned_at IS NULL) OR (returned_at IS NOT NULL AND checked_out_at IS NOT NULL)"
           )
  end
end
