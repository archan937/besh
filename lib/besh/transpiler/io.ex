defmodule Besh.Transpiler.IO do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(
             ast = {{:., _, [{:__aliases__, _, [:IO]}, :inspect]}, _, [value | options]},
             %{debug: debug, tab: tab} = opts
           ) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        label =
          case options |> List.flatten() |> Keyword.get(:label) do
            label when is_binary(label) -> "\"#{label}: \""
            _ -> ""
          end

        inspected =
          {:inspect, [], [value]}
          |> nt(opts)
          |> String.trim()

        indent(tab, "echo #{label}" <> inspected)
      end

      defp t(
             ast = {{:., _, [{:__aliases__, _, [:IO]}, :puts]}, _, [string]},
             %{debug: debug, tab: tab} = opts
           ) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        string = nt(string, opts)
        indent(tab, "echo #{string}")
      end

      defp t(
             ast = {{:., _, [{:__aliases__, _, [:IO]}, :write]}, _, [string]},
             %{debug: debug, tab: tab} = opts
           ) do
        if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

        string = nt(string, opts)
        indent(tab, "echo -n #{string}")
      end
    end
  end
end
