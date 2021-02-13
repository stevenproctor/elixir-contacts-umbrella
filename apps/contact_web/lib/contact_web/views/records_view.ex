defmodule ContactWeb.RecordsView do
  use ContactWeb, :view

  def render("create.json", %{}) do
    %{status: "received line"}
  end

  def render("show.json", %{contacts: contacts}) do
    %{contacts: Enum.map(contacts, &(&1))}
  end

  defp contact_json(contact) do
    contact
  end
end
