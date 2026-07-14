defmodule MarginaliaWeb.SubmissionsLive do
  @moduledoc """
  Main: form and feedback display.
  """
  use MarginaliaWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, loading: false, text: "", response: "", streaming: false, model: "llama3.2")}
  end

  def handle_event("analyze", %{"prompt" => prompt}, socket) do
    model = socket.assigns[:model] || "llama3.2"
    Marginalia.Ollama.stream_completion(prompt, model, self())
    {:noreply, assign(socket, loading: true)}
  end

  def handle_event("select_model", %{"model" => model}, socket) do
    {:noreply, assign(socket, model: model)}
  end

  def handle_info({:data, chunk}, socket) do
    new_text = socket.assigns.text <> chunk
    {:noreply, assign(socket, text: new_text)}
  end
  
  # each token arriving from Task
  def handle_info({:token, token}, socket) do
    {:noreply, assign(socket, response: socket.assigns.response <> token)}
  end

  def handle_info(:done, socket) do
    {:noreply, assign(socket, streaming: false, loading: false)}
  end

  def handle_info({:error, reason}, socket) do
    {:noreply, assign(socket, response: "Error: #{reason}", streaming: false, loading: false)}
  end
end
