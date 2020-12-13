defmodule Besh.Transpiler.Primitives do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      defp t(ast, %{debug: debug, tab: tab, context: context} = opts) when is_list(ast) do
        log(ast, debug, __ENV__)

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
        log(ast, debug, __ENV__)

        prefix = if Enum.member?([:inspection, :arithmetic], context), do: "", else: "$"
        indent(tab, "#{prefix}#{name}")
      end

      defp t(ast, %{debug: debug, tab: tab}) when is_binary(ast) do
        log(ast, debug, __ENV__)
        indent(tab, inspect(ast))
      end

      defp t(ast, %{debug: debug, tab: tab}) do
        log(ast, debug, __ENV__)
        indent(tab, "#{ast}")
      end
    end
  end
end
