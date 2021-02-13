defmodule ContactWeb.RecordsController do
  use ContactWeb, :controller

  def create(conn, %{"line" => line}, load_line \\ &ContactServer.load_line/1) do
    Task.start(fn -> load_line.(line) end)
    render(conn, "create.json")
  end

  def show(conn, params, get_contacts \\ &ContactServer.contacts/0)
  def show(conn, %{"sort_by" => "email"}, get_contacts) do
    render_contacts(conn, &ContactServer.by_email/1, get_contacts)
  end

  def show(conn, %{"sort_by" => "name"}, get_contacts) do
    render_contacts(conn, &ContactServer.by_last_name/1, get_contacts)
  end

  def show(conn, %{"sort_by" => "birthdate"}, get_contacts) do
    render_contacts(conn, &ContactServer.by_birthday/1, get_contacts)
  end

  def show(conn, _, _) do
    raise(ContactWeb.NotFoundError, "no route found")
  end

  def render_contacts(conn, sort_by, get_contacts) do
    contacts = get_contacts.()
      |> sort_by.()

    render(conn, "show.json", contacts: contacts)
  end
end
