defmodule ContactCLI do
  @moduledoc """
  Documentation for `ContactCLI`.
  """

  def main(args) do
    options = [strict: []]
    {_, files, _} = OptionParser.parse(args, options)
    IO.inspect files
  end
end
