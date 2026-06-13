defmodule Marginalia.Ollama do
  @moduledoc """
  Top-level interface for Ollama integration.
  Delegates to Client for actual implementation.
  """

  defdelegate stream_completion(prompt, model, pid), to: Marginalia.Ollama.Client
end
