defmodule ReviewScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :review_scraper,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
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
      # HTTP server mocking
      {:bypass, "~> 2.1", only: :test},

      # Run tests on file change
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},

      # Static code analysis
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      tmwtd: ["test.watch --seed 0 --max-failures 1"]
    ]
  end
end
