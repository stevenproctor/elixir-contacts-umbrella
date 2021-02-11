defmodule ContactServer.Contact do

	@doc ~S"""
	Parses a `line` into a contact.

	## Examples

    iex> ContactServer.Contact.from_line "Grayson | Dick | foo@example.com | blue | 1995-12-31\r\n"
    {:ok, %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]}}

    iex> ContactServer.Contact.from_line "Gordon, Barbara, bar@example.com, black, 1996-10-13"
    {:ok, %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]}}

    iex> ContactServer.Contact.from_line "Drake Tim baz@example.com red 2005-07-24"
    {:ok, %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]}}

    iex> ContactServer.Contact.from_line "Brown, Stephanie, baz@example.com, red, 2005/07/24"
    {:error, :invalid_birthdate_format}

    iex> ContactServer.Contact.from_line "Todd;Jason;bad@example.com;red;2000-10-13"
    {:error, :unknown_delimiter}
	"""
  def from_line(line) do
		line
			|> String.trim
			|> parse_line
			|> make_contact
  end


  defp parse_line(line) do
    cond do
      5 == length(c = Regex.split(~r{ \| }, line)) ->
        {:ok, c}
      5 == length(c = Regex.split(~r{, }, line)) ->
        {:ok, c}
      5 == length(c = Regex.split(~r{ }, line)) ->
        {:ok, c}
      true
        -> {:error, :unknown_delimiter}
    end
  end

  defp make_contact({:ok, [last, first, email, color, dob_str]}) do
    case Date.from_iso8601(dob_str) do
      {:ok, dob } ->
         {:ok, %{last_name: last, first_name: first, email: email, favorite_color: color, dob: dob }}
      {:error, :invalid_format} ->
         {:error, :invalid_birthdate_format }
		end
  end

  defp make_contact(err = {:error, _}) do
      err
  end
end
