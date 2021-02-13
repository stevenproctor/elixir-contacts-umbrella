defmodule ContactWeb.RecordsControllerTest do
  use ContactWeb.ConnCase

  test "POST /records", %{conn: conn} do
    payload = %{"line" => "Grayson Dick foo@example.com blue 1995-12-31"}
    conn = post(conn, "/records", payload)
    assert json_response(conn, 200) == %{"status" => "received line"}
  end

  describe "show" do
    for {sort_by, sort_fn} <- [
          {"email", &ContactServer.by_email/1},
          {"name", &ContactServer.by_last_name/1},
          {"birthdate", &ContactServer.by_birthday/1},
        ] do

      test "#{sort_by}", %{conn: conn} do
        params = %{"sort_by" => unquote(sort_by)}
        fake_server = ContactWeb.RecordsControllerTest.FakeContactServer

        conn = conn
          |> Phoenix.Controller.put_view(ContactWeb.RecordsView)
          |> ContactWeb.RecordsController.show(params, fake_server)

        expected_contacts = fake_server.contacts
          |> unquote(sort_fn).()
          |> Enum.map(&in_json_format/1)

        assert json_response(conn, 200) == %{"contacts" => expected_contacts}
      end
    end
  end

  defp in_json_format(x) do
    x
      |> Jason.encode!
      |> Jason.decode!
  end

  defmodule FakeContactServer do
    def contacts do
      [
        %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
        %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
        %{last_name: "Gordon", first_name: "James", email: "jim@example.com", favorite_color: "blue", dob: ~D[1965-02-14]},
        %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
      ]
    end
  end
end
