defmodule LineServerWeb.Router do
  use LineServerWeb, :router

  get "/lines/:line_number", LineServerWeb.LineController, :get_line
end
