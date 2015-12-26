defmodule Expensive.PageControllerTest do
  use Expensive.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Expensive"
  end
end
