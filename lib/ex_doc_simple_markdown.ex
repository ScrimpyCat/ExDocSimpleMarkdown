defmodule ExDocSimpleMarkdown do
    @moduledoc """
      A SimpleMarkdown processor for ExDoc.

      Provides configurable options for the assets (`:assets`),
      before_closing_head_tag (`:head_tag`), before_closing_body_tag
      (`:body_tag`) behaviours defined by ExDoc. As well as the option
      to enable or disable pretty codeblocks (`:pretty_codeblocks`).

        config :ex_doc_simple_markdown, [
                assets: [{ "dist/hello-js.js", "alert('hello');" }],
                head_tag: "<script src=\\"dist/hello-js.js\\"></script>",
                body_tag: "<script>alert('goodbye');</script>",
                pretty_codeblocks: false
            ]
    ]
    """

    @behaviour ExDoc.Markdown

    @impl ExDoc.Markdown
    def to_html(input, _) do
        html = SimpleMarkdown.convert(input)

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
