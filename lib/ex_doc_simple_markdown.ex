defmodule ExDocSimpleMarkdown do
    @moduledoc """
      A SimpleMarkdown processor for ExDoc.

      Provides configurable options for the assets (`:assets`),
      before_closing_head_tag (`:head_tag`), before_closing_body_tag
      (`:body_tag`) behaviours defined by ExDoc (when using a version earlier
      than v0.21.0). As well as the option to enable or disable pretty
      codeblocks (`:pretty_codeblocks`), manipulate the rules (`:rules`), change
      the renderer (`:renderer`), and specify modules that implement the
      extensions behaviour (`:extensions`).

        config :ex_doc_simple_markdown, [
                assets: [{ "dist/hello-js.js", "alert('hello');" }], \# Has no effect in ExDoc v0.21.0 and later
                head_tag: "<script src=\\"dist/hello-js.js\\"></script>", \# Has no effect in ExDoc v0.21.0 and later
                body_tag: "<script>alert('goodbye');</script>", \# Has no effect in ExDoc v0.21.0 and later
                pretty_codeblocks: false,
                rules: fn rules ->
                    # Manipulate the rules
                    rules
                end,
                renderer: &MyHTMLRenderer.render/1,
                extensions: [
                    MyCustomExtension
                ]
            ]

      Extensions can optionally be passed to the `:markdown_processor_options`
      option in `ex_doc`.
    """

    @behaviour ExDoc.Markdown

    @impl ExDoc.Markdown
    def to_ast(input, opts), do: to_html(input, opts) |> SimpleMarkdown.Renderer.HTML.Utilities.html_to_ast

    @impl ExDoc.Markdown
    def to_html(input, opts) do
        if Application.get_env(:ex_doc_simple_markdown, :init_extensions, true) do
            configure(Mix.Project.config[:docs][:markdown_processor_options] || [])
        end

        extensions = Application.get_env(:ex_doc_simple_markdown, :extensions, [])
        input = Enum.reduce(extensions, input, &(&1.input(&2, opts)))

        rules = SimpleMarkdown.Parser.rules
        rules = case Application.get_env(:ex_doc_simple_markdown, :rules) do
            nil -> rules
            fun -> fun.(rules)
        end
        rules = Enum.reduce(extensions, rules, &(&1.rules(&2, opts)))

        renderer = Application.get_env(:ex_doc_simple_markdown, :renderer, &SimpleMarkdown.Renderer.HTML.render/1)

        html = SimpleMarkdown.convert(input, parser: rules, render: renderer)

        html = if Application.get_env(:ex_doc_simple_markdown, :pretty_codeblocks, true) do
            if Version.match?(ExDoc.version, ">= 0.19.0") do
                apply(ExDoc.Highlighter, :highlight_code_blocks, [html])
            else
                apply(ExDoc.Markdown, :pretty_codeblocks, [html])
            end
        else
            html
        end

        Enum.reduce(extensions, html, &(&1.output(&2, opts)))
    end

    @impl ExDoc.Markdown
    def assets(_), do: Application.get_env(:ex_doc_simple_markdown, :assets, [])

    @impl ExDoc.Markdown
    def before_closing_head_tag(_), do: Application.get_env(:ex_doc_simple_markdown, :head_tag, "")

    @impl ExDoc.Markdown
    def before_closing_body_tag(_), do: Application.get_env(:ex_doc_simple_markdown, :body_tag, "")

    @impl ExDoc.Markdown
    def configure(config) do
        Application.put_env(:ex_doc_simple_markdown, :init_extensions, false)

        extensions = Enum.reduce((config[:extensions] || []), Application.get_env(:ex_doc_simple_markdown, :extensions, []), &([&1|&2]))
        Application.put_env(:ex_doc_simple_markdown, :extensions, extensions)
        Enum.each(extensions, &(&1.init()))

        :ok
    end
end
