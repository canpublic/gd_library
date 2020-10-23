defmodule GDLibraryWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use GDLibraryWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(GDLibraryWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(GDLibraryWeb.ErrorView)
    |> render(:"404")
  end

  # This clause handles generic error strings
  def call(conn, {:error, error_string}) when is_binary(error_string) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{errors: [error_string]})
  end
end
