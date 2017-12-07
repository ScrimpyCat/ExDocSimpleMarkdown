defmodule ExDocSimpleMarkdown do
    @behaviour ExDoc.Markdown

    @impl ExDoc.Markdown
    def to_html(input, _), do: SimpleMarkdown.convert(input)

    @impl ExDoc.Markdown
    def assets(_), do: Application.get_env(:ex_doc_simple_markdown, :assets, [])

    @impl ExDoc.Markdown
    def before_closing_head_tag(_), do: Application.get_env(:ex_doc_simple_markdown, :head_tag, "")

    @impl ExDoc.Markdown
    def before_closing_body_tag(_), do: Application.get_env(:ex_doc_simple_markdown, :body_tag, "")

    @impl ExDoc.Markdown
    def configure(_), do: :ok
end
