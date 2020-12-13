defmodule Besh.Transpiler.Arithmetics do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @arithmetic_operators [:+, :-, :*, :/]

      defp t(
             ast = {operator, _, [left, right]},
             %{debug: debug, tab: tab, context: context} = opts
           )
           when operator in @arithmetic_operators do
        log(ast, debug, __ENV__)

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
