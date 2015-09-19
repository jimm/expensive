defmodule Expensive.TransactionController do
  use Expensive.Web, :controller

  alias Expensive.Transaction
  alias Expensive.Category
  alias Expensive.Presenters.Category, as: CategoryPresenter

  plug :scrub_params, "transaction" when action in [:create, :update]

  def index(conn, _params) do
    transactions = Repo.all(from c in Transaction, preload: [:category])
    render(conn, "index.html", transactions: transactions)
  end

  def new(conn, _params) do
    changeset = Transaction.changeset(%Transaction{})
    render(conn, "new.html", changeset: changeset,
           categories: CategoryPresenter.for_menu(Repo.all(Category)))
  end

  def create(conn, %{"transaction" => transaction_params}) do
    changeset = Transaction.changeset(%Transaction{}, transaction_params)

    case Repo.insert(changeset) do
      {:ok, _transaction} ->
        conn
        |> put_flash(:info, "Transaction created successfully.")
        |> redirect(to: transaction_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset,
               categories: CategoryPresenter.for_menu(Repo.all(Category)))
    end
  end

  def show(conn, %{"id" => id}) do
    transaction = Repo.get!(Transaction, id)
    render(conn, "show.html", transaction: transaction)
  end

  def edit(conn, %{"id" => id}) do
    transaction = Repo.get!(Transaction, id)
    changeset = Transaction.changeset(transaction)
    render(conn, "edit.html", transaction: transaction, changeset: changeset,
           categories: CategoryPresenter.for_menu(Repo.all(Category)))
  end

  def update(conn, %{"id" => id, "transaction" => transaction_params}) do
    transaction = Repo.get!(Transaction, id)
    changeset = Transaction.changeset(transaction, transaction_params)

    case Repo.update(changeset) do
      {:ok, transaction} ->
        conn
        |> put_flash(:info, "Transaction updated successfully.")
        |> redirect(to: transaction_path(conn, :show, transaction))
      {:error, changeset} ->
        render(conn, "edit.html", transaction: transaction, changeset: changeset,
               categories: CategoryPresenter.for_menu(Repo.all(Category)))
    end
  end

  def delete(conn, %{"id" => id}) do
    transaction = Repo.get!(Transaction, id)
    Repo.delete!(transaction)
    conn
    |> put_flash(:info, "Transaction deleted successfully.")
    |> redirect(to: transaction_path(conn, :index))
  end
end
