defmodule PgContrivance.Mixfile do
  use Mix.Project

  @version "0.11.1-dev"

  def project do
    [app: :pg_contrivance,
     description: description,
     version: @version,
     elixir: "~> 1.2",
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
    [{:postgrex, github: "ericmj/postgrex"},
     {:poolboy, "~> 1.5"},
     # Docs
     {:ex_doc, "~> 0.11.4", only: [:dev, :docs]},
     {:earmark, "~> 0.2.0", only: [:dev, :docs]},
     {:inch_ex, ">= 0.0.0", only: :docs},
     # Test/Analysis
     {:credo, "~> 0.3.5", only: [:dev, :test]},
     # Optional
     {:sbroker, "~> 0.7", optional: true}]
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
