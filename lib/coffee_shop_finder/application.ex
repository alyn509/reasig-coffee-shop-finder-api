defmodule CoffeeShopFinder.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CoffeeShopFinderWeb.Telemetry,
      {DNSCluster,
       query: Application.get_env(:coffee_shop_finder, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: CoffeeShopFinder.PubSub},
      # Start a worker by calling: CoffeeShopFinder.Worker.start_link(arg)
      # {CoffeeShopFinder.Worker, arg},
      # Start to serve requests, typically the last entry
      CoffeeShopFinderWeb.Endpoint,
      CoffeeShopFinder.Data.DataStore
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CoffeeShopFinder.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CoffeeShopFinderWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
