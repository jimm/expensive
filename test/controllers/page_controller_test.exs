defmodule Expensive.PageControllerTest do
  use Expensive.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Expensive"
    assert html_response(conn, 200) =~ "The penultimate home budget"
  end
end
