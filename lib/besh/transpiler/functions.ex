defmodule Besh.Transpiler.Functions do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {:def, _, [{name, _, args}, [do: block]]}, %{debug: debug, tab: tab} = opts) do
        log(ast, debug, __ENV__)

        args =
          args
          |> List.wrap()
          |> Enum.reduce({1, ""}, fn {arg, _, nil}, {index, args} ->
            {index + 1, args <> " #{arg}=\"$#{index}\""}
          end)
          |> elem(1)
          |> case do
            "" -> ""
            args -> "\n" <> indent(tab + @tab_size, "local#{args}")
          end

        Enum.join(
          [
            "",
            indent(tab, "function #{name}() {#{args}"),
            t(block, Map.put(opts, :tab, tab + @tab_size)),
            indent(tab, "}"),
            ""
          ],
          "\n"
        )
      end

      defp t(ast = {:return, _, [value]}, %{debug: debug, tab: tab} = opts) do
        log(ast, debug, __ENV__)
        indent(tab, "echo #{nt(value, opts, context: :return)}")
      end

      defp t(ast = {name, _, args}, %{debug: debug, tab: tab} = opts)
           when is_atom(name) and is_list(args) do
        log(ast, debug, __ENV__)
        indent(tab, "$(#{name} " <> nt(args, opts, context: :return) <> ")")
      end
    end
  end
end
