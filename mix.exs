defmodule Kina.MixProject do
  use Mix.Project

  def project do
    [
      app: :kina,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      package: package(),
      description: description(),
      name: "Kina",
      source_url: "https://github.com/insprac/kina"
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  def description do
    "Define and parse data structures."
  end

  def package do
    [
      name: "kina",
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/insprac/kina"}
    ]
  end
end
