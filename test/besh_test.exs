defmodule BeshTest do
  use ExUnit.Case

  test "transpiles hello_world.ex", do: assert_transpiles("hello_world")

  defp assert_transpiles(name) do
    expected = "#!/bin/bash\n\n#{Besh.transpile("examples/#{name}.ex")}\n"
    actual = File.read!("test/expected/#{name}.sh")
    assert expected == actual
  end
end
