defmodule Marginalia.Ollama.Client do
  @moduledoc """
  HTTP client wrapper for Ollama streaming API.
  """

  @system_prompt "You are an experienced university writing instructor. Provide: strengths, weaknesses, and suggestions for improvement. Be constructive and concise."

  def stream_completion(prompt, model, pid) when is_pid(pid) and is_binary(prompt) and is_binary(model) do
    body = %{
      model: model,
      messages: [%{role: "system", content: @system_prompt}, %{role: "user", content: prompt}],
      stream: true
    }
    
    into_fn = fn {:data, chunk}, acc -> 
      buffer = acc <> chunk
      {lines, remainder} = split_complete_lines(buffer)

      Enum.each(lines, fn line -> 
        case Marginalia.Ollama.Response.parse_chunk(line) do
          {:ok, token} -> send(pid, {:token, token})
          {:done, _} -> send(pid, :done)
          {:error, reason} -> send(pid, {:error, reason})
        end
      end)
      
      {:cont, remainder}
    end

    case Req.post("#{base_url()}/api/chat", json: body, into: into_fn) do 
      {:ok, %{status: 200}} -> :ok
      {:ok, %{status: status}} -> send(pid, {:error, {:http_error, status}})
      {:error, reason} -> send(pid, {:error, reason})
    end
  end

  defp base_url, do: Application.get_env(:marginalia, :ollama_host, "http://localhost:11434")

  defp split_complete_lines(buffer) do
    parts = String.split(buffer, "\n")
    {complete, [remainder]} = Enum.split(parts, -1)
    {Enum.reject(complete, &(&1 == "")), remainder}
  end
end
