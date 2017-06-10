defmodule PgContrivance.Mixfile do
  use Mix.Project

  @version "0.11.3-dev"

  def project do
    [app: :pg_contrivance,
     description: description,
     version: @version,
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     # ExDoc
     name: "PgContrivance",
     source_url: "https://github.com/plamb/pg_contrivance",
     docs: [source_ref: "v#{@version}", main: PgContrivance.Run, extras: ["README.md"]],
     deps: deps,
   package: package]
  end

  def application do
    [
      applications: [:logger, :postgrex],
      mod: {PgContrivance.App, []}
    ]
  end

  defp deps do
    [
     {:postgrex, "~> 0.12"},
     {:poolboy, "~> 1.5"},
     # Docs
     {:ex_doc, "~> 0.14", only: [:dev, :docs]},
     {:earmark, "~> 1.0", only: [:dev, :docs]},
     {:inch_ex, ">= 0.0.0", only: :docs},
     # Test/Analysis
     {:credo, "~> 0.4", only: [:dev, :test]},
     # Optional
     {:sbroker, "~> 1.0.0", optional: true}]
  end

  def package do
    [maintainers: ["Paul Lamb"],
     licenses: ["New BSD"],
     links: %{"GitHub" => "https://github.com/plamb/pg_contrivance"}]
  end

  defp description do
    "A layer on top of postgrex for exploiting the power of Postgresql and SQL."
  end

end
