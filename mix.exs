defmodule FastAtom.MixProject do
  use Mix.Project

  @source_url "https://github.com/benfb/fast_atom"
  @version "0.4.1"

  def project do
    [
      app: :fast_atom,
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # hex
      description: "Fast Elixir Atom feed parser, a NIF wrapper around the Rust Atom crate",
      package: package(),

      # docs
      homepage_url: "https://benfb.github.io/fast_atom/",
      docs: docs(),

      # rustler
      start_permanent: Mix.env() == :prod,
      compilers: Mix.compilers(),
      rustler_crates: [fastatom: []]
    ]
  end

  defp package() do
    [
      files: [
        "lib",
        "native/fastatom/.cargo",
        "native/fastatom/src",
        "native/fastatom/Cargo.toml",
        "native/fastatom/Cargo.lock",
        "mix.exs",
        "README.md",
        "LICENSE"
      ],
      maintainers: ["Ben BAiley"],
      licenses: ["Apache-2.0"],
      links: %{
        "Changelog" => "#{@source_url}/blob/master/CHANGELOG.md",
        "GitHub" => @source_url
      }
    ]
  end

  defp docs() do
    [
      main: "readme",
      markdown_processor: ExDoc.Markdown.Earmark,
      extras: ["README.md", "CHANGELOG.md", "LICENSE"],
      source_ref: "v#{@version}",
      source_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # rust
      {:rustler, "~> 0.23.0"},

      # docs
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
