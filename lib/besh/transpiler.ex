defmodule Besh.Transpiler do
  @moduledoc """
  Transpiles Elixir code to Bash.
  """

  alias Besh.Transpiler.{
    Arithmetics,
    Comparisons,
    Conditionals,
    Functions,
    IntegerOperations,
    Loops,
    Primitives,
    Sigils,
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
    |> String.replace(~r/\n\n(done|esac|fi)/, "\n\\1")
    |> String.replace(~r/(done|esac|fi)\n\s*\n\s*\n/, "\\1\n\n")
    |> String.replace(~r/(; do|; then|\) \{)\n\n/, "\\1\n")
    |> String.trim()
  end

  defp t(ast = {:__block__, _, block}, %{debug: debug} = opts) do
    log(ast, debug, __ENV__)

    block
    |> Enum.map(fn ast -> t(ast, opts) end)
    |> Enum.join("\n")
  end

  defp t(ast = {:break, _, nil}, %{debug: debug, tab: tab}) do
    log(ast, debug, __ENV__)
    indent(tab, "break")
  end

  defp t(ast = {:inspect, _, [value]}, %{debug: debug, tab: tab} = opts) do
    log(ast, debug, __ENV__)

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
  use Sigils
  use Variables
  use Functions
  use Primitives

  defp log(ast, debug, %{file: file, line: line}) do
    if debug do
      [
        IO.ANSI.yellow(),
        Path.basename(file, ".ex"),
        ":#{line} ",
        IO.ANSI.light_black(),
        inspect(ast, pretty: true),
        IO.ANSI.reset()
      ]
      |> Enum.join("")
      |> IO.puts()
    end
  end

  defp indent(tab, string) do
    String.duplicate(" ", tab) <> string
  end
end
