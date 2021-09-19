defmodule Kundi.MixProject do
  use Mix.Project

  def project do
    [
      app: :kundi,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :cowboy],
      env: [
        # Port for HTTP-listener
        port: 8080,
        ## Size of board
        width: 10,
        height: 10,
        ## Dead timeout
        dead_timeout: 5000
      ],
      mod: { KundiApp, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:cowboy, "~> 2.9"},
      {:json, "~> 1.4"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
    ]
  end
end
