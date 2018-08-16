defmodule CeeLogFormatter.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cee_log_formatter,
      build_embedded: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      elixir: "~> 1.4",
      package: package(),
      start_permanent: Mix.env() == :prod,
      version: "0.2.0"
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp description do
    """
    A log formatter for the CEE format.
    """
  end

  defp package do
    [
      name: :cee_log_formatter,
      files: ["lib", "mix.exs", "README.md"],
      maintainers: ["Donald Plummer"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/avvo/cee_log_formatter"}
    ]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:poison, ">= 0.1.0"}
    ]
  end
end
