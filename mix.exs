defmodule PgContrivance.Mixfile do
  use Mix.Project

  @version "0.10.1"

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
    [applications: [:logger, :postgrex],
     mod: {PgContrivance, []}]
  end

  defp deps do
    [{:postgrex, github: "ericmj/postgrex", ref: "38eae1a9375af08688e8a421c26df533b67fed22"}, # updated 1/16/2016 from head of master
     {:ex_doc, "~> 0.11.2", only: [:dev, :docs]},
     {:earmark, "~> 0.2.0", only: [:dev, :docs]},
     {:credo, "~> 0.2.5", only: [:dev, :test]}]
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
