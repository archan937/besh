defmodule Besh.Transpiler.Comparisons do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
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

      defp t(ast = {operator, _, [left, right]}, debug, tab)
           when operator in @compound_operators do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        left = t(left, debug)
        right = t(right, debug)

        indent(tab, "#{left} #{Keyword.get(@compounds, operator)} #{right}")
      end

      defp t(ast = {:is_empty, _, [expression]}, debug, _tab) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        "-z #{t(expression, debug)}"
      end

      defp t(ast = {:is_not_empty, _, [expression]}, debug, _tab) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        "-n #{t(expression, debug)}"
      end
    end
  end
end
