defmodule LineServerWeb.LineControllerTest do
  use LineServerWeb.ConnCase

  test "returns 200 when the line exists" do
    resp = build_conn() |> get("/lines/#{1}") |> text_response(200)

    assert resp == "\n"
  end

  test "returns 415 when the line does not exist" do
    resp = build_conn() |> get("/lines/#{100}") |> text_response(415)

    assert resp == "Error: line not found."
  end

  test "returns 400 when the line is not an integer" do
    resp = build_conn() |> get("/lines/word") |> text_response(400)

    assert resp == "Error: line not an integer."
  end
end
