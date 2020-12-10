defmodule Besh do
  @moduledoc """
  Transpiles Elixir files to Bash.
  """

  @operators [:+, :-, :*, :/]

  @spec transpile(binary, boolean) :: binary
  def transpile(input, debug \\ false) do
    {:ok, code} =
      input
      |> Path.expand()
      |> File.read()

    code
    |> Code.string_to_quoted!()
    |> Macro.prewalk(fn ast ->
      t(ast, debug)
    end)
    |> case do
      {:__block__, [], block} ->
        Enum.join(block, "\n")

      ast ->
        ast
    end
  end

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :inspect]}, _, args}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    [value | options] = args
    options = List.flatten(options)
    value = t(value, debug)

    label = Keyword.get(options, :label)
    array = Keyword.get(options, :array)

    prefix = if label, do: "\"#{label}: \"", else: ""
    postfix = if array, do: "[@]", else: "@Q"

    "echo #{prefix}" <> String.replace("${#{value}#{postfix}}", "${$", "${")
  end

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :puts]}, _, [string]}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    string = t(string, debug)

    "echo #{string}"
  end

  defp t(ast = {{:., _, [{:__aliases__, _, [:IO]}, :write]}, _, [string]}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    string = t(string, debug)

    "echo -n #{string}"
  end

  defp t(ast = {:=, _, [{name, _, nil}, value]}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    value = t(value, debug)

    "#{name}=#{value}"
  end

  defp t(ast = {:<>, _, [left, right]}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    left = t(left, debug)
    right = t(right, debug)

    "#{left}#{right}"
  end

  defp t(ast = {:<<>>, _, terms}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    terms
    |> Enum.map(fn
      {:"::", _, [{_, _, [ast]}, _]} ->
        t(ast, debug)

      ast ->
        ast
    end)
    |> Enum.map(fn value ->
      if String.match?(value, ~r/^\$\w+$/) do
        String.replace(value, "$", "${") <> "}"
      else
        value
      end
    end)
    |> Enum.join("")
    |> inspect()
  end

  defp t(ast = {:inspect, _, args}, debug) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    [value | options] = args
    options = List.flatten(options)
    value = t(value, debug)

    array = Keyword.get(options, :array)
    postfix = if array, do: "[@]", else: "@Q"

    String.replace("${#{value}#{postfix}}", "${$", "${")
  end

  defp t(ast = {operator, _, [left, right]}, debug) when operator in @operators do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    left = t(left, debug)
    right = t(right, debug)

    "$((#{left}#{operator}#{right}))"
  end

  defp t(ast = {name, _, nil}, debug) when is_atom(name) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    "$#{name}"
  end

  defp t(ast, debug) when is_list(ast) do
    if debug, do: IO.inspect(ast, label: "Line #{__ENV__.line}")

    items =
      ast
      |> Enum.map(fn ast -> t(ast, debug) end)
      |> Enum.join(" ")

    "(" <> items <> ")"
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
