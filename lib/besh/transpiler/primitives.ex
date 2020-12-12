defmodule Besh.Transpiler.Primitives do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast, debug, tab) when is_list(ast) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        items =
          ast
          |> Enum.map(fn ast -> t(ast, debug) end)
          |> Enum.join(" ")

        indent(tab, "(" <> items <> ")")
      end

      defp t(ast = {:break, _, nil}, debug, tab) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        indent(tab, "break")
      end

      defp t(ast = {name, _, nil}, debug, tab) when is_atom(name) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        indent(tab, "$#{name}")
      end

      defp t(ast, debug, tab) when is_binary(ast) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        indent(tab, inspect(ast))
      end

      defp t(ast, debug, tab) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        indent(tab, "#{ast}")
      end
    end
  end
end
