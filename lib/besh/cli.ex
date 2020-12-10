defmodule Besh.CLI do
  @moduledoc """
  Besh escript module.
  """

  @help """
  Usage: besh [options] FILE
      -d, --debug                 Print mismatched Elixir AST
      -e, --execute               Execute generate script
      -h, --help                  Show this help message
      -o, --output                Write the script to this file
  """

  @options [
    switches: [
      debug: :boolean,
      execute: :boolean,
      help: :boolean,
      output: :string
    ],
    aliases: [
      d: :debug,
      e: :execute,
      h: :help,
      o: :output
    ]
  ]

  def main(argv) do
    {options, args, _invalid} = OptionParser.parse(argv, @options)
    run(args, Enum.into(options, %{}))
  end

  defp run(_args, %{help: true}), do: @help |> String.trim() |> IO.puts()

  defp run([input], options) do
    script = "#!/bin/bash\n\n" <> Besh.transpile(input, Map.get(options, :debug))

    case options do
      %{output: output} ->
        write(output, script)

      %{execute: true} ->
        file = "/tmp/ex.sh"
        write(file, script)

        "bash"
        |> System.cmd([file])
        |> elem(0)
        |> IO.write()

      _ ->
        IO.puts(script)
    end
  end

  defp run(_args, help: true), do: IO.puts("Missing input file. Abort.")

  defp write(file, script) do
    file
    |> Path.expand()
    |> File.write(script, [:write])
  end
end
