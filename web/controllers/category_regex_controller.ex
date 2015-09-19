defmodule Expensive.CategoryRegexController do
  use Expensive.Web, :controller

  alias Expensive.CategoryRegex

  plug :scrub_params, "category_regex" when action in [:create, :update]

  def index(conn, _params) do
    category_regexes = Repo.all(CategoryRegex)
    render(conn, "index.html", category_regexes: category_regexes)
  end

  def new(conn, _params) do
    changeset = CategoryRegex.changeset(%CategoryRegex{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category_regex" => category_regex_params}) do
    changeset = CategoryRegex.changeset(%CategoryRegex{}, category_regex_params)

    case Repo.insert(changeset) do
      {:ok, _category_regex} ->
        conn
        |> put_flash(:info, "Category regex created successfully.")
        |> redirect(to: category_regex_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category_regex = Repo.get!(CategoryRegex, id)
    render(conn, "show.html", category_regex: category_regex)
  end

  def edit(conn, %{"id" => id}) do
    category_regex = Repo.get!(CategoryRegex, id)
    changeset = CategoryRegex.changeset(category_regex)
    render(conn, "edit.html", category_regex: category_regex, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category_regex" => category_regex_params}) do
    category_regex = Repo.get!(CategoryRegex, id)
    changeset = CategoryRegex.changeset(category_regex, category_regex_params)

    case Repo.update(changeset) do
      {:ok, category_regex} ->
        conn
        |> put_flash(:info, "Category regex updated successfully.")
        |> redirect(to: category_regex_path(conn, :show, category_regex))
      {:error, changeset} ->
        render(conn, "edit.html", category_regex: category_regex, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category_regex = Repo.get!(CategoryRegex, id)
    Repo.delete!(category_regex)
    conn
    |> put_flash(:info, "Category regex deleted successfully.")
    |> redirect(to: category_regex_path(conn, :index))
  end
end
