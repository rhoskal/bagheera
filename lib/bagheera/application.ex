defmodule Bagheera.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Bagheera.Repo,
      # Start the Telemetry supervisor
      BagheeraWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Bagheera.PubSub},
      # Start the Endpoint (http/https)
      BagheeraWeb.Endpoint
      # Start a worker by calling: Bagheera.Worker.start_link(arg)
      # {Bagheera.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bagheera.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BagheeraWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
