defmodule ExDocSimpleMarkdown do
    @moduledoc """
      A SimpleMarkdown processor for ExDoc.

      Provides configurable options for the assets (`:assets`),
      before_closing_head_tag (`:head_tag`), before_closing_body_tag
      (`:body_tag`) behaviours defined by ExDoc. As well as the option
      to enable or disable pretty codeblocks (`:pretty_codeblocks`),
      manipulate the rules (`:rules`), and change the renderer (`:renderer`).

        config :ex_doc_simple_markdown, [
                assets: [{ "dist/hello-js.js", "alert('hello');" }],
                head_tag: "<script src=\\"dist/hello-js.js\\"></script>",
                body_tag: "<script>alert('goodbye');</script>",
                pretty_codeblocks: false,
                rules: fn rules ->
                    # Manipulate the rules
                    rules
                end,
                renderer: &MyHTMLRenderer.render/1
            ]
    """

    @behaviour ExDoc.Markdown

    @impl ExDoc.Markdown
    def to_html(input, _) do
        rules = Application.get_env(:simple_markdown, :rules, [])
        rules = case Application.get_env(:ex_doc_simple_markdown, :rules) do
            nil -> rules
            fun -> fun.(rules)
        end

        renderer = Application.get_env(:ex_doc_simple_markdown, :renderer, &SimpleMarkdown.Renderer.HTML.render/1)

        html = SimpleMarkdown.convert(input, parser: rules, render: renderer)

        if Application.get_env(:ex_doc_simple_markdown, :pretty_codeblocks, true) do
            ExDoc.Markdown.pretty_codeblocks(html)
        else
            html
        end
    end

    @impl ExDoc.Markdown
    def assets(_), do: Application.get_env(:ex_doc_simple_markdown, :assets, [])

    @impl ExDoc.Markdown
    def before_closing_head_tag(_), do: Application.get_env(:ex_doc_simple_markdown, :head_tag, "")

    @impl ExDoc.Markdown
    def before_closing_body_tag(_), do: Application.get_env(:ex_doc_simple_markdown, :body_tag, "")

    @impl ExDoc.Markdown
    def configure(_), do: :ok
end
