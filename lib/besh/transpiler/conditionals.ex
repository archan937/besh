defmodule Besh.Transpiler.Conditionals do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {:{}, _, [{:{}, _, [expression]}]}, %{debug: debug, context: context} = opts) do
        log(ast, debug, __ENV__)

        {open, close} =
          if context == :arithmetic do
            {"", ""}
          else
            {"(( ", " ))"}
          end

        open <> t(expression, Map.put(opts, :context, :arithmetic)) <> close
      end

      defp t(ast = {:if, _, [expression, then]}, %{debug: debug} = opts) do
        log(ast, debug, __ENV__)

        if_block = Keyword.get(then, :do)
        else_block = Keyword.get(then, :else)

        cases = [%{expression: expression, block: if_block}]
        cases = if else_block, do: cases ++ [%{expression: true, block: else_block}], else: cases

        to_if_statement(cases, opts)
      end

      defp t(ast = {:cond, _, [[do: cases]]}, %{debug: debug} = opts) do
        log(ast, debug, __ENV__)

        cases =
          Enum.map(cases, fn {:->, _, [[expression], block]} ->
            %{expression: expression, block: block}
          end)

        to_if_statement(cases, opts)
      end

      defp t(ast = {:case, _, [expression, [do: cases]]}, %{debug: debug, tab: tab} = opts) do
        log(ast, debug, __ENV__)

        cases =
          cases
          |> Enum.flat_map(fn {:->, _, [[match], block]} ->
            [
              t(match, opts) <> ")",
              t(block, Map.put(opts, :tab, tab + @tab_size)),
              indent(tab + @tab_size, ";;")
            ]
          end)
          |> Enum.join("\n")

        Enum.join(
          [
            "",
            indent(tab, "case #{nt(expression, opts)} in"),
            cases,
            indent(tab, "esac")
          ],
          "\n"
        )
      end

      defp to_if_statement(cases, %{tab: tab, context: context} = opts) do
        {open, close} =
          if context == :arithmetic do
            {"(( ", " ))"}
          else
            {"", ""}
          end

        count = length(cases)
        opts = Map.put(opts, :tab, tab + @tab_size)

        cases
        |> Enum.reduce({0, [""]}, fn %{expression: expression, block: block}, {i, lines} ->
          {prefix, expression, postfix} =
            cond do
              i == 0 ->
                {"if #{open}", nt(expression, opts), "#{close}; then"}

              i == count - 1 and expression == true ->
                {"else", "", ""}

              true ->
                {"elif #{open}", nt(expression, opts), "#{close}; then"}
            end

          {i + 1,
           lines ++
             [
               indent(tab, "#{prefix}#{expression}#{postfix}"),
               t(block, opts)
             ]}
        end)
        |> elem(1)
        |> Kernel.++([indent(tab, "fi")])
        |> Enum.join("\n")
      end
    end
  end
end
