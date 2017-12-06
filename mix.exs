defmodule ExDocSimpleMarkdown.Mixfile do
    use Mix.Project

    def project do
        [
            app: :ex_doc_simple_markdown,
            version: "0.1.0",
            elixir: "~> 1.5",
            start_permanent: Mix.env == :prod,
            deps: deps()
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [extra_applications: [:logger]]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [
            { :simple_markdown, "~> 0.3" },
            { :ex_doc, "~> 0.18" }
        ]
    end
end
