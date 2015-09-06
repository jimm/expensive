defmodule Expensive.ImportControllerTest do
  use Expensive.ConnCase

  test "GET /import" do
    conn = get conn(), "/import"
    assert html_response(conn, 200) =~ "Import"
  end
end
