defmodule ContactCLI do
  @moduledoc """
  Documentation for `ContactCLI`.
  """

  def main(args) do
    options = [strict: []]
    {_, files, _} = OptionParser.parse(args, options)
    Task.await_many(import_files(files))
    display_contacts(ContactServer.contacts)
  end

  defp import_files(files) do
    files
      |> Enum.map(&(Task.async(fn -> import_file(&1) end)))
  end

  defp import_file(file) do
    IO.inspect file, label: "importing file: #{file}"
    file
      |> File.stream!
      |> Enum.map(&ContactServer.load_line/1)
  end

  defp date_format do
    "%m/%d/%Y"
  end

  defp display_contacts(contacts) do
    display_groups = %{
      "Contacts by email" => &ContactServer.by_email/1,
      "Contacts by birthday" => &ContactServer.by_birthday/1,
      "Contacts by lastname" => &ContactServer.by_last_name/1,
    }

    display_groups
      |> Enum.each(fn {header, order_by} -> print_contacts(contacts, header, date_format(), order_by) end)
  end

  defp print_contacts(contacts, header, date_format, order_by \\ fn x -> x end) do
    IO.puts "\n\n"
    IO.puts header
    IO.puts String.duplicate("-", 40)

    contacts
      |> order_by.()
      |> Enum.each(fn x -> print_contact(x, date_format) end)
  end

  defp print_contact(contact, date_format) do
    IO.puts format_contact(contact, date_format)
  end

  defp format_contact(%{last_name: last_name, first_name: first_name, email: email, favorite_color: color, dob: dob}, date_format) do
    "#{last_name}\t\t\t#{first_name}\t\t\t#{email}\t\t\t#{color}\t\t\t#{Calendar.strftime(dob, date_format)}"
  end
end
