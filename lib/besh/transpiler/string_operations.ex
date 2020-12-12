defmodule Besh.Transpiler.StringOperations do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
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
    end
  end
end
