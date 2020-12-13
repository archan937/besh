defmodule Besh.Transpiler.Conditionals do
  @moduledoc false

  defmacro __using__(_) do
    quote do
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

      defp t(
             ast = {:if, _, [expression, [do: block]]},
             %{debug: debug, tab: tab, context: context} = opts
           ) do
        log(ast, debug, __ENV__)

        opts = Map.put(opts, :tab, tab + @tab_size)
        expression = nt(expression, opts)

        {open, close} =
          if context == :arithmetic do
            {"(( ", " ))"}
          else
            {"", ""}
          end

        Enum.join(
          [
            "",
            indent(tab, "if #{open}#{expression}#{close}; then"),
            t(block, opts),
            indent(tab, "fi")
          ],
          "\n"
        )
      end
    end
  end
end
