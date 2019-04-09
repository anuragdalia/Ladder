defmodule Ladder.MixProject do
  use Mix.Project

  @repo_url "https://github.com/anuragdalia/Ladder.git"

  def project do
    [
      app: :ladder,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "Ladder",
      docs: [
        main: "Ladder",
        source_url: @repo_url,
      ],

      # Package
      package: package(),
      description: "A simple odm for mongodb written in elixir"
    ]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{
        "GitHub" => @repo_url
      }
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
