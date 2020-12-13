defmodule Besh.Transpiler.Primitives do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast, %{debug: debug, tab: tab, context: context} = opts) when is_list(ast) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        items =
          ast
          |> Enum.map(fn ast -> nt(ast, opts) end)
          |> Enum.join(" ")

        {open, close} =
          if context == :forloop do
            {"", ""}
          else
            {"(", ")"}
          end

        indent(tab, "#{open}#{items}#{close}")
      end

      defp t(ast = {name, _, nil}, %{debug: debug, tab: tab, context: context})
           when is_atom(name) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        prefix = if Enum.member?([:inspection, :arithmetic], context), do: "", else: "$"
        indent(tab, "#{prefix}#{name}")
      end

      defp t(ast, %{debug: debug, tab: tab}) when is_binary(ast) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        indent(tab, inspect(ast))
      end

      defp t(ast, %{debug: debug, tab: tab}) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
        indent(tab, "#{ast}")
      end
    end
  end
end
