defmodule ContactWeb.RecordsController do
  use ContactWeb, :controller

  def create(conn, %{"line" => line}) do
    Task.start(fn -> ContactServer.load_line(line) end)
    render(conn, "create.json")
  end

  def show(conn, params, contact_server \\ ContactServer)
  def show(conn, %{"sort_by" => "email"}, contact_server) do
    render_contacts(conn, &ContactServer.by_email/1, contact_server)
  end

  def show(conn, %{"sort_by" => "name"}, contact_server) do
    render_contacts(conn, &ContactServer.by_last_name/1, contact_server)
  end

  def show(conn, %{"sort_by" => "birthdate"}, contact_server) do
    render_contacts(conn, &ContactServer.by_birthday/1, contact_server)
  end

  def render_contacts(conn, sort_by, contact_server) do
    contacts = contact_server.contacts
      |> sort_by.()

    render(conn, "show.json", contacts: contacts)
  end
end
