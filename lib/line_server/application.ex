defmodule LineServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    index_bootstrap(file_path())

    children = [
      # Start the endpoint when the application starts
      LineServerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LineServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LineServerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp index_bootstrap(file_path) do
    {:ok, index} = LineServer.IndexCreator.create(file_path)
    LineServer.IndexRepository.save(index)
  end

  defp file_path do
    Application.get_env(:line_server, :file_path)
  end
end
