defmodule MarginaliaWeb.Live.ChatLive do
  @moduledoc """
  Handles async tasks for streaming responses
  """
  use MarginaliaWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, messages: [], current_response: "", streaming: false)}
  end

  def handle_event("analyze", %{"message" => message}, socket) do
    pid = self()
    model = socket.assigns[:model] || "llama3.2"

    Task.start(fn ->
      body = Jason.encode!(%{
        model: model,
        messages: [%{role: "user", content: message}],
        stream: true
      })

      case Req.post("http://localhost:11434/api/chat",
        body: body,
        headers: [{"content-type", "application/json"}],
        into: fn {:data, chunk}, acc ->
          case Marginalia.Ollama.Response.parse_chunk(chunk) do
            {:ok, token} ->
              send(pid, {:token, token})
            {:error, reason} ->
              send(pid, {:error, reason})
          end
          {:cont, acc}
        end
      ) do
        {:ok, _response} ->
          send(pid, :done)
        {:error, reason} ->
          send(pid, {:error, "Request failed: #{inspect(reason)}"})
      end
    end)

    {:noreply, assign(socket, response: "", streaming: true)}
  end

  def handle_info({:token, token}, socket) do
    {:noreply, assign(socket, response: socket.assigns.response <> token)}
  end

  def handle_info(:done, socket) do
    {:noreply, assign(socket, streaming: false)}
  end

  def handle_info({:error, reason}, socket) do
    {:noreply, assign(socket, response: "Error: #{reason}", streaming: false)}
  end
end
