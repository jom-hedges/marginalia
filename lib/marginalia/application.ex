defmodule Marginalia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MarginaliaWeb.Telemetry,
      Marginalia.Repo,
      {DNSCluster, query: Application.get_env(:marginalia, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Marginalia.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Marginalia.Finch},
      # Start a worker by calling: Marginalia.Worker.start_link(arg)
      # {Marginalia.Worker, arg},
      # Start to serve requests, typically the last entry
      MarginaliaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Marginalia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MarginaliaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
