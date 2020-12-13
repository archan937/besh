defmodule Besh.Transpiler.Arithmetics do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      @arithmetic_operators [:+, :-, :*, :/]

      defp t(
             ast = {operator, _, [left, right]},
             %{debug: debug, tab: tab, context: context} = opts
           )
           when operator in @arithmetic_operators do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        left = nt(left, opts)
        right = nt(right, opts)

        {open, close} =
          if context == :arithmetic do
            {"", ""}
          else
            {"$((", "))"}
          end

        indent(tab, "#{open}#{left}#{operator}#{right}#{close}")
      end
    end
  end
end
