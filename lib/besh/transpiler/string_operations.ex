defmodule Besh.Transpiler.StringOperations do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {:<>, _, [left, right]}, %{debug: debug, tab: tab} = opts) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        left = nt(left, opts)
        right = nt(right, opts)

        indent(tab, "#{left}#{right}")
      end

      defp t(ast = {:<<>>, _, terms}, %{debug: debug} = opts) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        terms
        |> Enum.map(fn
          {:"::", _, [{_, _, [ast]}, _]} ->
            nt(ast, opts)

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
