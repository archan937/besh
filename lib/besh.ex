defmodule Besh do
  @moduledoc """
  Transpiles Elixir files to Bash.
  """

  alias Besh.Transpiler

  @spec transpile(binary, boolean) :: binary
  def transpile(input, debug \\ false) do
    input
    |> Path.expand()
    |> File.read!()
    |> Transpiler.to_bash(debug)
  end
end
