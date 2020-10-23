defmodule GDLibraryWeb.ChangesetView do
  use GDLibraryWeb, :view

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
    |> Enum.reduce([], fn {key, errors}, acc ->
      errors
      |> Enum.map(fn error ->
        "#{Phoenix.Naming.humanize(key)} #{error}."
      end)
      |> Enum.concat(acc)
    end)
  end
end
