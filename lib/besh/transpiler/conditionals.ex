defmodule Besh.Transpiler.Conditionals do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
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
    end
  end
end
