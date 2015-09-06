defmodule Expensive.ImportController do
  use Expensive.Web, :controller

  def index(conn, params) do
    render conn, "index.html", %{errors: nil}
  end

  def create(conn, params) do
    errors = if params["transactions"] do
      Expensive.Importer.transactions(params["file"].path)
    else
      Expensive.Importer.checks(params["file"].path)
    end
    case errors do
      :ok ->
        render conn, "index.html", %{errors: nil}
      {:error, error_messages} ->
        render conn, "index.html", %{errors: error_messages}
    end
  end
end
