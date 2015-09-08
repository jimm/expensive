defmodule Expensive.ImportController do
  use Expensive.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", %{errors: nil}
  end

  def create(conn, params) do
    result = if params["transactions"] do
      Expensive.Importer.transactions(params["file"].path)
    else
      Expensive.Importer.checks(params["file"].path)
    end
    case result do
      :ok ->
        render conn, "index.html", %{errors: nil}
      {:error, errors} ->
        render conn, "index.html", %{errors: errors}
    end
  end
end
