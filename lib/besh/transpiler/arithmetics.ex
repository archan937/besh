defmodule Besh.Transpiler.Arithmetics do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      @arithmetic_operators [:+, :-, :*, :/]

      defp t(ast = {operator, _, [left, right]}, debug, tab)
           when operator in @arithmetic_operators do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        left = t(left, debug)
        right = t(right, debug)

        indent(tab, "$((#{left}#{operator}#{right}))")
      end
    end
  end
end
