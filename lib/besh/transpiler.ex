defmodule Besh.Transpiler do
  @moduledoc """
  Transpiles Elixir code to Bash.
  """

  alias Besh.Transpiler.{
    Arithmetics,
    Comparisons,
    Conditionals,
    Loops,
    Primitives,
    StringOperations
  }

  alias Besh.Transpiler.IO, as: TranspilerIO

  @tab_size 2

  def to_bash(elixir, debug \\ false) do
    elixir
    |> Code.string_to_quoted!()
    |> Macro.prewalk(fn ast ->
      t(ast, debug)
    end)
    |> String.trim()
  end

  defp t(_ast, _debug, tab \\ 0)

  defp t(ast = {:__block__, _, block}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    block
    |> Enum.map(fn ast -> t(ast, debug, tab) end)
    |> Enum.join("\n")
  end

  defp t(ast = {:=, _, [{name, _, nil}, value]}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    value = t(value, debug)
    indent(tab, "#{name}=#{value}")
  end

  defp t(ast = {:inspect, _, args}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    [value | options] = args
    options = List.flatten(options)
    value = t(value, debug)

    array = Keyword.get(options, :array)
    postfix = if array, do: "[@]", else: "@Q"

    indent(tab, String.replace("${#{value}#{postfix}}", "${$", "${"))
  end

  use TranspilerIO
  use Conditionals
  use Loops
  use Comparisons
  use Arithmetics
  use StringOperations
  use Primitives

  defp indent(tab, string) do
    String.duplicate(" ", Enum.max([0, tab])) <> string
  end
end
