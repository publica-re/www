defmodule Publicare.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Publicare.Repo,
      # Start the Telemetry supervisor
      PublicareWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Publicare.PubSub},
      # Start the Endpoint (http/https)
      PublicareWeb.Endpoint
      # Start a worker by calling: Publicare.Worker.start_link(arg)
      # {Publicare.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Publicare.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PublicareWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
