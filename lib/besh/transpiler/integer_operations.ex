defmodule Besh.Transpiler.IntegerOperations do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      @increment_operators [:+, :-]

      defp t(ast = {{:., _, [{name, _, nil}, operator]}, _, []}, %{
             debug: debug,
             tab: tab,
             context: context
           })
           when operator in @increment_operators do
        log(ast, debug, __ENV__)

        {open, close} =
          if context == :arithmetic do
            {"", ""}
          else
            {"((", "))"}
          end

        indent(tab, "#{open}#{name}#{operator}#{operator}#{close}")
      end
    end
  end
end
