defmodule Besh.Transpiler.Variables do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {:=, _, [{name, _, nil}, value]}, %{debug: debug, tab: tab} = opts) do
        log(ast, debug, __ENV__)

        value = nt(value, opts)
        indent(tab, "#{name}=#{value}")
      end
    end
  end
end
