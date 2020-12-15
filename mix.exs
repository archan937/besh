defmodule Besh.MixProject do
  use Mix.Project

  def project do
    [
      app: :besh,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      name: "Besh",
      description: description(),
      deps: deps(),
      package: package(),
      escript: [
        main_module: Besh.CLI
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  defp description do
    """
    Transpile Elixir scripts to Bash scripts
    """
  end

  defp deps do
    [
      {:excoveralls, "~> 0.12.3", only: :test}
    ]
  end

  defp package do
    [
      maintainers: ["Paul Engel"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/archan937/besh"}
    ]
  end
end
