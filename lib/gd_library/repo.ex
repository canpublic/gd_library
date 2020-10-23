defmodule GDLibrary.Repo do
  use Ecto.Repo,
    otp_app: :gd_library,
    adapter: Ecto.Adapters.Postgres
end
