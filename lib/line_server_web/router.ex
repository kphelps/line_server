defmodule LineServerWeb.Router do
  use LineServerWeb, :router

  scope "/", LineServerWeb do
    get "/lines/:line_number", LineController, :get_line
  end
end
