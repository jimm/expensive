defmodule Expensive.PageController do
  use Expensive.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
