defmodule ContactServer do
  @moduledoc """
  Public interface for the Contact Server application
  """

  @doc """
  Load a contact line into the store of Contacts
  """
  def load_line(line)do
    line
      |> ContactServer.Contact.from_line
      |> create_contact
  end

	@doc ~S"""
	Sorts the contacts by email (ascending)
  and falls back to last_name (descending)

	## Examples

    iex> ContactServer.by_email([
    ...>   %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ...>   %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
    ...>   %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
    ...> ])
    [
       %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
       %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
       %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
    ]

    iex> ContactServer.by_email([
    ...>   %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ...>   %{last_name: "Todd", first_name: "Jason", email: "baz@example.com", favorite_color: "red", dob: ~D[1999-12-31]},
    ...>   %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
    ...>   %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
    ...> ])
    [
       %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
       %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
       %{last_name: "Todd", first_name: "Jason", email: "baz@example.com", favorite_color: "red", dob: ~D[1999-12-31]},
       %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
    ]
	"""
  def by_email(contacts) do
    contacts
      |> Enum.sort_by(&(&1), &email_compare/2)
  end

	@doc ~S"""
	Sorts the contacts by last_name (descending)

	## Examples

    iex> ContactServer.by_last_name([
    ...>   %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ...>   %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
    ...>   %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
    ...> ])
    [
       %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
       %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
       %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ]

  ### If same comes back in order of list
    iex> ContactServer.by_last_name([
    ...>   %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ...>   %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
    ...>   %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
    ...>   %{last_name: "Gordon", first_name: "James", email: "jim@example.com", favorite_color: "blue", dob: ~D[1965-02-14]},
    ...> ])
    [
       %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
       %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
       %{last_name: "Gordon", first_name: "James", email: "jim@example.com", favorite_color: "blue", dob: ~D[1965-02-14]},
       %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ]
	"""
  def by_last_name(contacts) do
    # note: if need to do last and first both in same order
    # can compare the tuple since in same direction
    # &{&1.last_name, &1.first_name}

    contacts
      |> Enum.sort_by(&(&1.last_name), :desc)
  end

	@doc ~S"""
	Sorts the contacts by birthday (ascending)

	## Examples

    iex> ContactServer.by_last_name([
    ...>   %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ...>   %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
    ...>   %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
    ...> ])
    [
       %{last_name: "Grayson", first_name: "Dick", email: "foo@example.com", favorite_color: "blue", dob: ~D[1995-12-31]},
       %{last_name: "Gordon", first_name: "Barbara", email: "bar@example.com", favorite_color: "black", dob: ~D[1996-10-13]},
       %{last_name: "Drake", first_name: "Tim", email: "baz@example.com", favorite_color: "red", dob: ~D[2005-07-24]},
    ]
	"""
  def by_birthday(contacts) do
    contacts
      |> Enum.sort_by(&(&1.dob), {:asc, Date})
  end

  def contacts do
    {:ok, contacts} = ContactServer.ContactStore.get_all(:contacts)
    contacts
  end

  defp create_contact(error = {:error, _}) do
    error
  end
  defp create_contact({:ok, contact}) do
    ContactServer.ContactStore.create(:contacts, contact)
  end

  defp email_compare(contact1, contact2) do
    cond do
      contact1.email == contact2.email
        -> contact1.last_name < contact2.last_name
      true
        -> contact1.email > contact2.email
    end
  end

end
