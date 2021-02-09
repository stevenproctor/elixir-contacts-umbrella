defmodule ContactServerTest do
  use ExUnit.Case
  doctest ContactServer

  test "greets the world" do
    assert ContactServer.hello() == :world
  end
end
