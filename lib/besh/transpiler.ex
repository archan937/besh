defmodule Besh.Transpiler do
  @moduledoc """
  Transpiles Elixir code to Bash.
  """

  alias Besh.Transpiler.{
    Arithmetics,
    Comparisons,
    Conditionals,
    IntegerOperations,
    Loops,
    Primitives,
    StringOperations,
    Variables
  }

  alias Besh.Transpiler.IO, as: TranspilerIO

  @tab_size 2

  def to_bash(elixir, debug \\ false) do
    elixir
    |> Code.string_to_quoted!()
    |> Macro.prewalk(fn ast ->
      t(ast, %{debug: debug, tab: 0, context: :script})
    end)
    |> String.trim()
  end

  defp t(ast = {:__block__, _, block}, %{debug: debug} = opts) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    block
    |> Enum.map(fn ast -> t(ast, opts) end)
    |> Enum.join("\n")
  end

  defp t(ast = {:break, _, nil}, %{debug: debug, tab: tab}) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    indent(tab, "break")
  end

  defp t(ast = {:inspect, _, [value]}, %{debug: debug, tab: tab} = opts) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    {ast, postfix} =
      case value do
        {:@, _, [value]} -> {value, "[@]"}
        _ -> {value, "@Q"}
      end

    indent(tab, "${#{nt(ast, opts, context: :inspection)}#{postfix}}")
  end

  defp nt(ast, opts, overrides \\ []) do
    opts =
      opts
      |> Map.put(:tab, 0)
      |> Map.merge(Enum.into(overrides, %{}))

    t(ast, opts)
  end

  use TranspilerIO
  use Conditionals
  use Loops
  use Comparisons
  use Arithmetics
  use IntegerOperations
  use StringOperations
  use Variables
  use Primitives

  defp indent(tab, string) do
    String.duplicate(" ", tab) <> string
  end
end
