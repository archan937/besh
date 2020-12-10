defmodule Besh.MixProject do
  use Mix.Project

  def project do
    [
      app: :besh,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      escript: [
        main_module: Besh.CLI,
        path: "bin/besh"
      ]
    ]
  end
end
