defmodule Besh.Transpiler.Loops do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {:while, _, [expression, [do: block]]}, %{debug: debug, tab: tab} = opts) do
        log(ast, debug, __ENV__)

        opts = Map.put(opts, :tab, tab + @tab_size)
        expression = nt(expression, opts)

        expression =
          if String.match?(expression, ~r/^\[.*?\]$/) do
            expression
          else
            "[ #{expression} ]"
          end

        Enum.join(
          [
            "",
            indent(tab, "while #{expression}; do"),
            t(block, opts),
            indent(tab, "done")
          ],
          "\n"
        )
      end

      defp t(
             ast = {:for, _, [initializer, condition, step, [do: block]]},
             %{debug: debug, tab: tab} = opts
           ) do
        log(ast, debug, __ENV__)

        opts = Map.put(opts, :tab, tab + @tab_size)
        context = [context: :arithmetic]

        initializer = nt(initializer, opts, context)
        condition = nt(condition, opts, context)
        step = nt(step, opts, context)

        Enum.join(
          [
            "",
            indent(tab, "for (( #{initializer}; #{condition}; #{step} )); do"),
            t(block, opts),
            indent(tab, "done")
          ],
          "\n"
        )
      end

      defp t(
             ast = {:for, _, [{:<-, _, [{item, _, nil}, items]}, [do: block]]},
             %{debug: debug, tab: tab} = opts
           ) do
        log(ast, debug, __ENV__)

        opts = Map.put(opts, :tab, tab + @tab_size)

        Enum.join(
          [
            "",
            indent(tab, "for #{nt(item, opts)} in #{nt(items, opts, context: :forloop)}; do"),
            t(block, opts),
            indent(tab, "done")
          ],
          "\n"
        )
      end
    end
  end
end
