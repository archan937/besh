defmodule Besh.Transpiler.Conditionals do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {:{}, _, [{:{}, _, [expression]}]}, %{debug: debug, context: context} = opts) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

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
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

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
