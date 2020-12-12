defmodule Besh.Transpiler.Loops do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
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
    end
  end
end
