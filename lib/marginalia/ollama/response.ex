defmodule Marginalia.Ollama.Response do
  @moduledoc """
  Parsing and handling of Ollama streaming responses.
  """

  @doc """
  Process a chunk of streaming response from Ollama.
  Returns {:ok, token} or {:error, reason}
  """
  def parse_chunk(chunk) when is_binary(chunk) do
    case Jason.decode(chunk) do
      {:ok, %{"message" => %{"content" => token}}} ->
        {:ok, token}

      {:ok, %{"error" => error}} ->
        {:error, error}

      {:ok, _other} ->
        {:ok, ""}

      {:error, reason} ->
        {:error, "Failed to parse response: #{inspect(reason)}"}
    end
  end

  @doc """
  Check if response indicates streaming is complete.
  """
  def done?(%{"done" => true}), do: true
  def done?(_), do: false
end
