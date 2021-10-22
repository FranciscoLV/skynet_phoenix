defmodule SkynetPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SkynetPhoenix.Repo,
      # Start the Telemetry supervisor
      SkynetPhoenixWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SkynetPhoenix.PubSub},
      # Start the Endpoint (http/https)
      SkynetPhoenixWeb.Endpoint,
      # Start a worker by calling: SkynetPhoenix.Worker.start_link(arg)
      # {SkynetPhoenix.Worker, arg}
      {DynamicSupervisor, strategy: :one_for_one, name: Skynet},
      SkynetPhoenix.Commanded.Application,
      {Registry, keys: :unique, name: SkynetPhoenix.Terminator.Registry}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SkynetPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SkynetPhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
