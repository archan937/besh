defmodule Besh do
  @moduledoc """
  Transpiles Elixir files to Bash.
  """

  @arithmetic_operators [:+, :-, :*, :/]
  @string_comparison_operators [:==, :!=, :>, :<]

  @integer_comparisons [
    ==: "-eq",
    !=: "-ne",
    >: "-gt",
    >=: "-ge",
    <: "-lt",
    <=: "-le"
  ]

  @compounds [
    and: "&&",
    or: "||"
  ]

  @integer_comparison_operators Keyword.keys(@integer_comparisons)
  @compound_operators Keyword.keys(@compounds)
  @tab_size 2

  @spec transpile(binary, boolean) :: binary
  def transpile(input, debug \\ false) do
    {:ok, code} =
      input
      |> Path.expand()
      |> File.read()

    code
    |> Code.string_to_quoted!()
    |> Macro.prewalk(fn ast ->
      t(ast, debug)
    end)
    |> String.trim()
  end

  defp t(_ast, _debug, tab \\ 0)

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :inspect]}, _, args}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    [value | options] = args
    options = List.flatten(options)
    value = t(value, debug)

    label = Keyword.get(options, :label)
    array = Keyword.get(options, :array)

    prefix = if label, do: "\"#{label}: \"", else: ""
    postfix = if array, do: "[@]", else: "@Q"

    indent(tab, "echo #{prefix}" <> String.replace("${#{value}#{postfix}}", "${$", "${"))
  end

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :puts]}, _, [string]}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    string = t(string, debug)
    indent(tab, "echo #{string}")
  end

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :write]}, _, [string]}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    string = t(string, debug)
    indent(tab, "echo -n #{string}")
  end

  defp t(ast = {:=, _, [{name, _, nil}, value]}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    value = t(value, debug)
    indent(tab, "#{name}=#{value}")
  end

  defp t(ast = {operator, _, [left, right]}, debug, tab)
       when operator in @integer_comparison_operators do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    left = t(left, debug)
    right = t(right, debug)

    indent(tab, "[ #{left} #{Keyword.get(@integer_comparisons, operator)} #{right} ]")
  end

  defp t(ast = {{:., _, [left, operator]}, _, [right]}, debug, tab)
       when operator in @string_comparison_operators do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    left = t(left, debug)
    right = t(right, debug)

    indent(tab, "[ #{left} \\#{operator} #{right} ]")
  end

  defp t(ast = {operator, _, [left, right]}, debug, tab) when operator in @compound_operators do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    left = t(left, debug)
    right = t(right, debug)

    indent(tab, "#{left} #{Keyword.get(@compounds, operator)} #{right}")
  end

  defp t(ast = {:<>, _, [left, right]}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    left = t(left, debug)
    right = t(right, debug)

    indent(tab, "#{left}#{right}")
  end

  defp t(ast = {:<<>>, _, terms}, debug, _tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    terms
    |> Enum.map(fn
      {:"::", _, [{_, _, [ast]}, _]} ->
        t(ast, debug)

      ast ->
        ast
    end)
    |> Enum.map(fn value ->
      if String.match?(value, ~r/^\$\w+$/) do
        String.replace(value, "$", "${") <> "}"
      else
        value
      end
    end)
    |> Enum.join("")
    |> inspect()
  end

  defp t(ast = {:__block__, _, block}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    block
    |> Enum.map(fn ast -> t(ast, debug, tab) end)
    |> Enum.join("\n")
  end

  defp t(ast = {:break, _, nil}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    indent(tab, "break")
  end

  defp t(ast = {:if, _, [expression, [do: block]]}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    expression =
      expression
      |> t(debug)
      |> String.replace(~r/(^\[ | \]$)/, "")

    Enum.join(
      [
        "",
        indent(tab, "if [ #{expression} ]; then"),
        t(block, debug, tab + @tab_size),
        indent(tab, "fi")
      ],
      "\n"
    )
  end

  defp t(ast = {:while, _, [expression, [do: block]]}, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    expression =
      expression
      |> t(debug)
      |> String.replace(~r/(^\[ | \]$)/, "")

    Enum.join(
      [
        "",
        indent(tab, "while [ #{expression} ]; do"),
        t(block, debug, tab + @tab_size),
        indent(tab, "done")
      ],
      "\n"
    )
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

  defp t(ast = {:is_empty, _, [expression]}, debug, _tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    "-z #{t(expression, debug)}"
  end

  defp t(ast = {:is_present, _, [expression]}, debug, _tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    "-n #{t(expression, debug)}"
  end

  defp t(ast = {operator, _, [left, right]}, debug, tab) when operator in @arithmetic_operators do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    left = t(left, debug)
    right = t(right, debug)

    indent(tab, "$((#{left}#{operator}#{right}))")
  end

  defp t(ast, debug, tab) when is_list(ast) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    items =
      ast
      |> Enum.map(fn ast -> t(ast, debug) end)
      |> Enum.join(" ")

    indent(tab, "(" <> items <> ")")
  end

  defp t(ast = {name, _, nil}, debug, tab) when is_atom(name) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    indent(tab, "$#{name}")
  end

  defp t(ast, debug, tab) when is_binary(ast) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    indent(tab, inspect(ast))
  end

  defp t(ast, debug, tab) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    indent(tab, "#{ast}")
  end

  defp indent(tab, string) do
    String.duplicate(" ", Enum.max([0, tab])) <> string
  end
end
