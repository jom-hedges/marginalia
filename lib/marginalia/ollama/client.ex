defmodule Marginalia.Ollama.Client do
  @moduledoc """
  HTTP client wrapper for Ollama streaming API.
  """

  @base_url Application.compile_env(:marginalia, :ollama_host, "http://localhost:11434")
  @system_prompt "You are an experienced university writing instructor. Provide: strengths, weaknesses, and suggestions for improvement. Be constructive and concise."

  def stream_completion(prompt, model, pid) when is_pid(pid) and is_binary(prompt) and is_binary(model) do
    body = %{
      model: model,
      messages: [%{role: "system", content: @system_prompt}, %{role: "user", content: prompt}],
      stream: true
    }

    case Req.post(
      "#{@base_url}/api/chat",
      json: body,
      into: fn {:data, chunk}, acc -> 
        case Marginalia.Ollama.Response.parse_chunk(chunk) do
          {:ok, token} -> 
            send(pid, {:token, token})
          {:error, reason} -> 
            send(pid, {:error, reason})
        end

        {:cont, acc}
      end
    )
  end
end
