defmodule ContactWeb.RecordsControllerTest do
  use ContactWeb.ConnCase

  describe "create" do
    test "returns a Map with status of 'received line'", %{conn: conn} do
      payload = %{"line" => "Grayson Dick foo@example.com blue 1995-12-31"}

      conn = conn
        |> Phoenix.Controller.put_view(ContactWeb.RecordsView)
        |> ContactWeb.RecordsController.create(payload, fn _ -> end)

      assert json_response(conn, 200) == %{"status" => "received line"}
    end

    test "calls the 'load_line' function with the line", %{conn: conn} do
      parent = self()
      ref = make_ref()

      line = "Grayson Dick foo@example.com blue 1995-12-31"
      payload = %{"line" => line}

      fake_load_line = fn line ->
        send(parent, {ref, line})
      end

      conn = conn
        |> Phoenix.Controller.put_view(ContactWeb.RecordsView)
        |> ContactWeb.RecordsController.create(payload, fake_load_line)

      assert_receive {^ref, ^line}
    end
  end

  describe "show" do
    show_routes_with_sorters = [
      {"email", &ContactServer.by_email/1},
      {"name", &ContactServer.by_last_name/1},
      {"birthdate", &ContactServer.by_birthday/1},
    ]

    for {sort_by, sort_fn} <- show_routes_with_sorters  do
      test "#{sort_by}", %{conn: conn} do
        params = %{"sort_by" => unquote(sort_by)}

        conn = conn
          |> Phoenix.Controller.put_view(ContactWeb.RecordsView)
          |> ContactWeb.RecordsController.show(params, &fake_contacts/0)

        expected = fake_contacts()
          |> unquote(sort_fn).()
          |> Enum.map(&in_json_format/1)
          |> (fn x -> %{"contacts" => x} end).()

        assert json_response(conn, 200) == expected
      end
    end
  end

  defp in_json_format(x) do
    x
      |> Jason.encode!
      |> Jason.decode!
  end

  def fake_contacts do
    [
      %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
      %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
      %{last_name: "Gordon", first_name: "James", email: "jim@example.com", favorite_color: "blue", dob: ~D[1965-02-14]},
      %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ]
  end
end
