defmodule MarginaliaWeb.HomeLive do
  use MarginaliaWeb, :live_view
    
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("analyze", %{"prompt" => prompt}, socket) do
    handle_event("analyze", %{"prompt" => prompt, "model" => socket.assign.model})
  end

  def handle_event("analyze", %{"analyze", %{"prompt" => ""}, socket) do
    {:noreply, socket}
  end

  def handle_event("select_model", %{"model" => model}, socket) do
    {:noreply, assign(socket, :model, model)}
  end
end
