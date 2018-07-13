defmodule ExDocSimpleMarkdown.Extension do
    @doc """
      A callback called once before any conversion/doc generation is performed.
      Use this to perform any required initialisation.
    """
    @callback init() :: :ok

    @doc """
      A callback to modify the rule list before converting.
    """
    @callback rules(rules :: [Parsey.rule], opts :: any) :: [Parsey.rule]

    @doc """
      A callback to modify the text input.
    """
    @callback input(text :: String.t, opts :: any) :: String.t

    @doc """
      A callback to modify the HTML output.
    """
    @callback output(html :: String.t, opts :: any) :: String.t
end
