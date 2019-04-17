defmodule LineServerWeb.Router do
  use LineServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", LineServerWeb do
    pipe_through :api
  end
end
