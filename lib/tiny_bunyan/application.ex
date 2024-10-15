defmodule TinyBunyan.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TinyBunyanWeb.Telemetry,
      TinyBunyan.Repo,
      {DNSCluster, query: Application.get_env(:tiny_bunyan, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TinyBunyan.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TinyBunyan.Finch},
      # Start a worker by calling: TinyBunyan.Worker.start_link(arg)
      # {TinyBunyan.Worker, arg},
      # Start to serve requests, typically the last entry
      TinyBunyanWeb.Endpoint,
      {Cachex, name: TinyBunyan.Cachex}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TinyBunyan.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TinyBunyanWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
