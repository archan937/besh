defmodule Besh.Transpiler.Sigils do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      defp t(ast = {:sigil_b, _, [{:<<>>, _, [bash]}, []]}, %{debug: debug, tab: tab}) do
        log(ast, debug, __ENV__)
        indent(tab, bash)
      end
    end
  end
end
