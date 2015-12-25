defmodule Expensive.ReportController do
  use Expensive.Web, :controller
  alias Expensive.Reporter
  alias Expensive.Category
  alias Expensive.Transaction

  def index(conn, _params) do
    render conn, "index.html"
  end

  def budget(conn, _params) do
    categories = Repo.all(Category)
    transactions = Repo.all(Transactions)
    {data, years} = Reporter.budget(categories, transactions)
    render conn, "report.html", heading: "Budget", data: data, years: years
  end

  def taxes(conn, _params) do
    {data, years} = Reporter.taxes
    render conn, "report.html", heading: "Taxes", data: data, years: years
  end
end
