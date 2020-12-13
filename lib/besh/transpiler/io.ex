defmodule Besh.Transpiler.IO do
  @moduledoc false

  defmacro __using__(_) do
    quote location: :keep do
      defp t(
             ast = {{:., _, [{:__aliases__, _, [:IO]}, :inspect]}, _, [value | options]},
             %{debug: debug, tab: tab} = opts
           ) do
        log(ast, debug, __ENV__)

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
        log(ast, debug, __ENV__)

        string = nt(string, opts)
        indent(tab, "echo #{string}")
      end

      defp t(
             ast = {{:., _, [{:__aliases__, _, [:IO]}, :write]}, _, [string]},
             %{debug: debug, tab: tab} = opts
           ) do
        log(ast, debug, __ENV__)

        string = nt(string, opts)
        indent(tab, "echo -n #{string}")
      end
    end
  end
end
