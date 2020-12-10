defmodule BeshTest do
  use ExUnit.Case
  doctest Besh

  test "greets the world" do
    assert Besh.hello() == :world
  end
end
