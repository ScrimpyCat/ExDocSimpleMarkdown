defmodule ExDocSimpleMarkdown do
    @behaviour ExDoc.Markdown

    @impl ExDoc.Markdown
    def to_html(input, _) do
        SimpleMarkdown.convert(input)
    end

    @impl ExDoc.Markdown
    def assets(_), do: []

    @impl ExDoc.Markdown
    def before_closing_head_tag(_), do: ""

    @impl ExDoc.Markdown
    def before_closing_body_tag(_), do: ""

    @impl ExDoc.Markdown
    def configure(_), do: :ok
end
