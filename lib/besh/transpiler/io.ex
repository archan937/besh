defmodule Besh.Transpiler.IO do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :inspect]}, _, args}, debug, tab) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        [value | options] = args
        options = List.flatten(options)
        value = t(value, debug)

        label = Keyword.get(options, :label)
        array = Keyword.get(options, :array)

        prefix = if label, do: "\"#{label}: \"", else: ""
        postfix = if array, do: "[@]", else: "@Q"

        indent(tab, "echo #{prefix}" <> String.replace("${#{value}#{postfix}}", "${$", "${"))
      end

      defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :puts]}, _, [string]}, debug, tab) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        string = t(string, debug)
        indent(tab, "echo #{string}")
      end

      defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :write]}, _, [string]}, debug, tab) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        string = t(string, debug)
        indent(tab, "echo -n #{string}")
      end
    end
  end
end
