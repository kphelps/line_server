defmodule LineServerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :line_server

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger
  plug Plug.MethodOverride
  plug Plug.Head
  plug LineServerWeb.Router
end
