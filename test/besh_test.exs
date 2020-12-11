defmodule BeshTest do
  use ExUnit.Case

  test "transpiles hello_world.ex" do
    assert_transpiles("hello_world", """
    Hello world
    """)
  end

  test "transpiles write.ex" do
    assert_transpiles("write", "Hello world")
  end

  test "transpiles variables.ex" do
    assert_transpiles("variables", """
    '1'
    'string'
    'Concat'
    A: '3'
    B: '21'
    C: 1 2 str true false
    '3:21'
    '31 2 str true false'
    '1.1'
    """)
  end

  test "transpiles if.ex" do
    assert_transpiles("if", """
    Equal (strings)
    Not equal (strings)
    Greater than (strings)
    Less than (strings)
    Equal
    Not equal
    Greater than
    Greater or equal (greater)
    Greater or equal (equal)
    Less than
    Less or equal (less)
    Less or equal (equal)
    Zero-length
    Not zero-length
    And
    Or
    """)
  end

  test "transpiles while.ex" do
    assert_transpiles("while", """
    0
    1
    2
    3
    4
    """)
  end

  defp assert_transpiles(name, output) do
    expected = "#!/bin/bash\n\n#{Besh.transpile("examples/#{name}.ex")}\n"
    actual = File.read!("test/expected/#{name}.sh")
    assert expected == actual
    assert String.to_charlist(output) == :os.cmd('bin/besh -e examples/#{name}.ex')
  end
end
