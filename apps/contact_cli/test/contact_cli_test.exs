defmodule ContactCLITest do
  use ExUnit.Case
  doctest ContactCLI

  test "greets the world" do
    assert ContactCLI.hello() == :world
  end
end
