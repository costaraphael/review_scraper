defmodule ReviewScraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :review_scraper,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # HTML parsing
      {:floki, "~> 0.29.0"},

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
