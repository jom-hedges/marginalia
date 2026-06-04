defmodule Marginalia.Ollama do
  @base_url Application.compile_env(:marginalia, :ollama_host, "http://localhost:11434")

  def chat(message, model \\ "llama3.2", opts \\ []) do
    body = %{
      model: model,
      messages: messages,
      stream: true,
    }
    case Req.post("#{@base_url}/api/chat", json:body) do
      {:ok, %{status, 200, body: %{"message" => %{"content" => content}}}} -> 
        {:ok, content}
      {:ok, %{status: status, body: body}} -> 
        {:error, "HTTP #{status}: #{inspect(body)}"}
      {:error, reason} -> 
        {:error, reason}
    end
  end
end
