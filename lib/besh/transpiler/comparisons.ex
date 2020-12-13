defmodule Besh.Transpiler.Comparisons do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      @comparison_operators [
        :==,
        :!=,
        :>,
        :>=,
        :<,
        :<=
      ]

      @compounds [
        and: "&&",
        or: "||"
      ]

      @compound_operators Keyword.keys(@compounds)

      defp t(
             ast = {operator, _, [left, right]},
             %{debug: debug, tab: tab, context: context} = opts
           )
           when operator in @comparison_operators do
        log(ast, debug, __ENV__)

        left = nt(left, opts)
        right = nt(right, opts)

        {open, operator, close} =
          case context do
            :script ->
              operator = if Enum.member?([:>, :<], operator), do: "\\#{operator}", else: operator
              {"[ ", operator, " ]"}

            _ ->
              {"", operator, ""}
          end

        indent(tab, "#{open}#{left} #{operator} #{right}#{close}")
      end

      defp t(ast = {operator, _, [left, right]}, %{debug: debug, tab: tab} = opts)
           when operator in @compound_operators do
        log(ast, debug, __ENV__)

        left = nt(left, opts)
        right = nt(right, opts)

        indent(tab, "#{left} #{Keyword.get(@compounds, operator)} #{right}")
      end

      defp t(ast = {:is_empty, _, [expression]}, %{debug: debug, context: context} = opts) do
        log(ast, debug, __ENV__)

        {open, close} =
          case context do
            :script ->
              {"[ ", " ]"}

            _ ->
              {"", ""}
          end

        "#{open}-z #{nt(expression, opts)}#{close}"
      end

      defp t(ast = {:is_not_empty, _, [expression]}, %{debug: debug, context: context} = opts) do
        log(ast, debug, __ENV__)

        {open, close} =
          case context do
            :script ->
              {"[ ", " ]"}

            _ ->
              {"", ""}
          end

        "#{open}-n #{nt(expression, opts)}#{close}"
      end
    end
  end
end
