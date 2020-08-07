defmodule ExDocSimpleMarkdownTest do
    use ExUnit.Case
    doctest ExDocSimpleMarkdown

    test "ex_doc" do
        assert ExDocSimpleMarkdown != ExDoc.Markdown.get_markdown_processor()
        ExDoc.Markdown.put_markdown_processor(ExDocSimpleMarkdown)
        assert ExDocSimpleMarkdown == ExDoc.Markdown.get_markdown_processor()

        if Version.match?(ExDoc.version, ">= 0.22.0") do
            assert { "h1", [], "foo" } == ExDoc.Markdown.to_ast("#foo")
        else
            assert "<h1>foo</h1>" == ExDoc.Markdown.to_html("#foo")
        end
    end
end
