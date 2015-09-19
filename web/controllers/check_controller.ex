defmodule Expensive.CheckController do
  use Expensive.Web, :controller

  alias Expensive.Check
  alias Expensive.Category
  alias Expensive.Presenters.Category, as: CategoryPresenter

  plug :scrub_params, "check" when action in [:create, :update]

  def index(conn, _params) do
    checks = Repo.all(from c in Check, preload: [:category, :transaction])
    render(conn, "index.html", checks: checks)
  end

  def new(conn, _params) do
    changeset = Check.changeset(%Check{})
    render(conn, "new.html", changeset: changeset,
           categories: CategoryPresenter.for_menu(Repo.all(Category)))
  end

  def create(conn, %{"check" => check_params}) do
    changeset = Check.changeset(%Check{}, check_params)

    case Repo.insert(changeset) do
      {:ok, _check} ->
        conn
        |> put_flash(:info, "Check created successfully.")
        |> redirect(to: check_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset,
               categories: CategoryPresenter.for_menu(Repo.all(Category)))
    end
  end

  def show(conn, %{"id" => id}) do
    check = Repo.get!(Check, id)
    render(conn, "show.html", check: check)
  end

  def edit(conn, %{"id" => id}) do
    check = Repo.get!(Check, id)
    changeset = Check.changeset(check)
    render(conn, "edit.html", check: check, changeset: changeset,
           categories: CategoryPresenter.for_menu(Repo.all(Category)))
  end

  def update(conn, %{"id" => id, "check" => check_params}) do
    check = Repo.get!(Check, id)
    changeset = Check.changeset(check, check_params)

    case Repo.update(changeset) do
      {:ok, check} ->
        conn
        |> put_flash(:info, "Check updated successfully.")
        |> redirect(to: check_path(conn, :show, check))
      {:error, changeset} ->
        render(conn, "edit.html", check: check, changeset: changeset,
               categories: CategoryPresenter.for_menu(Repo.all(Category)))
    end
  end

  def delete(conn, %{"id" => id}) do
    check = Repo.get!(Check, id)
    Repo.delete!(check)
    conn
    |> put_flash(:info, "Check deleted successfully.")
    |> redirect(to: check_path(conn, :index))
  end
end
