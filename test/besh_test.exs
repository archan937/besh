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
    true
    true
    Yes
    Yes
    """)
  end

  test "transpiles cond.ex" do
    assert_transpiles("cond", """
    a
    b
    b
    c
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

  test "transpiles case.ex" do
    assert_transpiles("case", """
    Success
    No content
    Unauthorized
    Internal error
    Unknown
    """)
  end

  test "transpiles for.ex" do
    assert_transpiles("for", """
    10 9 8 7 6 5 4 3 2 1 Color = Blue
    Color = Green
    Color = Pink
    Color = White
    Color = Red
    My favorite color is Blue
    """)
  end

  test "transpiles raw.ex" do
    assert_transpiles("raw", """
    Hi!
    README.md
    """)
  end

  test "transpiles functions.ex" do
    assert_transpiles("functions", """
    Output: Hello, Paul!!!
    """)
  end

  defp assert_transpiles(name, output) do
    expected = File.read!("test/expected/#{name}.sh")
    actual = "#!/bin/bash\n\n#{Besh.transpile("examples/#{name}.ex")}\n"
    assert expected == actual
    assert String.to_charlist(output) == :os.cmd('bin/besh -e examples/#{name}.ex')
  end
end
