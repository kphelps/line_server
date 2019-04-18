defmodule LineServerWeb.LineController do
    use LineServerWeb, :controller
    alias LineServer.LineRetriever

  def get_line(conn, %{"line_number" => line_number_param}) do
    resp = conn |> put_resp_content_type("text/plain")

    if valid_number?(line_number_param) do
      resp |> send_resp(400, "Error: line not an integer.")
    else
      case LineRetriever.retrieve(String.to_integer(line_number_param)) do
        {:ok, line} -> resp |> send_resp(200, line)
        {:err, :notfound} -> resp |> send_resp(415, "Error: line not found.")
      end
    end
  end

  def valid_number?(n) do
    :error == Integer.parse(n)
  end
end
