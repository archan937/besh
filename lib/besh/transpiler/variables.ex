defmodule Besh.Transpiler.Variables do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {:=, _, [{name, _, nil}, value]}, %{debug: debug, tab: tab} = opts) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        value = nt(value, opts)
        indent(tab, "#{name}=#{value}")
      end
    end
  end
end
