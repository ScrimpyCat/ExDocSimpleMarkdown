defmodule ExDocSimpleMarkdown.Mixfile do
    use Mix.Project

    def project do
        [
            app: :ex_doc_simple_markdown,
            description: "A SimpleMarkdown processor for ExDoc.",
            version: "0.4.0",
            elixir: "~> 1.5",
            start_permanent: Mix.env == :prod,
            deps: deps(),
            package: package()
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [extra_applications: [:logger]]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [
            { :simple_markdown, "~> 0.6" },
            { :ex_doc, "~> 0.18" }
        ]
    end

    defp package do
        [
            maintainers: ["Stefan Johnson"],
            licenses: ["BSD 2-Clause"],
            links: %{ "GitHub" => "https://github.com/ScrimpyCat/ExDocSimpleMarkdown" }
        ]
    end
end
