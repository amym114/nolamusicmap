defmodule Notjazzfest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NotjazzfestWeb.Telemetry,
      Notjazzfest.Repo,
      {DNSCluster, query: Application.get_env(:notjazzfest, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Notjazzfest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Notjazzfest.Finch},
      {Geocoder.Supervisor, worker_config: [provider: Geocoder.Providers.GoogleMaps,  key: "AIzaSyDpsyPPpcGHKBgy8wtLwMgirm_fTjrBrTg"]},
      # Start a worker by calling: Notjazzfest.Worker.start_link(arg)
      # {Notjazzfest.Worker, arg},
      # Start to serve requests, typically the last entry
      NotjazzfestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Notjazzfest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NotjazzfestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
