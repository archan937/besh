defmodule Besh do
  @moduledoc """
  Transpiles Elixir files to Bash.
  """

  @spec transpile(binary, boolean) :: binary
  def transpile(input, debug \\ false) do
    {:ok, code} =
      input
      |> Path.expand()
      |> File.read()

    code
    |> Code.string_to_quoted!()
    |> Macro.postwalk(fn ast ->
      t(ast, debug)
    end)
    |> case do
      {:__block__, [], block} ->
        Enum.join(block, "\n")

      ast ->
        ast
    end
  end

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :puts]}, _, [string]}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    "echo #{string}"
  end

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :write]}, _, [string]}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    "echo -n #{string}"
  end

  defp t(ast = {:=, _, [name, value]}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    name = String.replace(name, ~r/^\$/, "")
    "#{name}=#{value}"
  end

  defp t(ast = {name, _, nil}, debug) when is_atom(name) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    "$#{name}"
  end

  defp t(ast, debug) when is_binary(ast) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    inspect(ast)
  end

  defp t(ast, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")
    ast
  end
end
