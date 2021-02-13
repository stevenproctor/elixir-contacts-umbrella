defmodule ContactWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ContactWeb.Telemetry,
      # Start the Endpoint (http/https)
      ContactWeb.Endpoint,
      # Start a worker by calling: ContactWeb.Worker.start_link(arg)
      # {ContactWeb.Worker, arg}
      {Phoenix.PubSub, name: ContactWeb.PubSub}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ContactWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ContactWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
