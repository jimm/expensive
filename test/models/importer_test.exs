defmodule Expensive.ImporterTest do
  use Expensive.ModelCase

  alias Expensive.Importer
  alias Expensive.Transaction
  alias Expensive.Check
  alias Expensive.Category

  test "load transactions, type 1" do
    assert :ok == Importer.transactions("test/models/transactions_1.csv")
    assert 5 == Repo.one(from t in Transaction, select: count(t.id))
    [[-3202, "Food Store"], [-2509, "Gas Station"], [10000, "Deposit"],
     [-1234, "Some Check"], [-5545, "Check # 334"]]
    |> Enum.map(&assert_amount_matches/1)
  end

  test "load transactions, type 1, creates checks" do
    assert 0 = Repo.one(from c in Check, select: count(c.id))
    assert :ok == Importer.transactions("test/models/transactions_1.csv")
    assert 2 = Repo.one(from c in Check, select: count(c.id))
  end

  test "load transactions, type 2" do
    assert :ok == Importer.transactions("test/models/transactions_2.csv")
    assert 4 == Repo.one(from t in Transaction, select: count(t.id))
    [[-8000, "A RESTAURANT"], [-1864, "ANOTHER RESTAURANT"],
     [-40003, "CHECK # 3387 REF # 017909492"], [10000, "DEPOSIT"]]
    |> Enum.map(&assert_amount_matches/1)
  end

  test "load transactions, type 3" do
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    assert 4 == Repo.one(from t in Transaction, select: count(t.id))
    [[123456, "PAY"], [-9033, "MONTHLY BILL"]] |> Enum.map(&assert_amount_matches/1)
    [[-7500, 4182], [-17500, 4217]] |> Enum.map(&assert_check_amount_matches/1)
  end

  test "do not create duplicate transactions" do
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    assert 4 == Repo.one(from t in Transaction, select: count(t.id))
  end

  test "load checks" do
    assert :ok == load_all_transactions_and_checks
    assert 6 == Repo.one(from c in Check, select: count(c.id))
    c = Repo.get!(Check, 3387)
    assert c.amount == 40003
    assert c.description == "Something"
  end

  test "link checks to transactions" do
    load_all_transactions_and_checks
    check = Repo.get!(Check, 3387)
    assert nil != check.transaction_id
    txn = Repo.get!(Transaction, check.transaction_id)
    assert txn.description =~ ~r{CHECK # 3387}
  end

  test "do not create duplicate checks" do
    assert :ok == load_all_transactions_and_checks
    assert :ok == Importer.checks("test/models/checks.csv")
    assert 6 == Repo.one(from c in Check, select: count(c.id))
  end

  test "set categories" do
    load_all_transactions_and_checks
    check = Repo.get!(Check, 4217) |> Repo.preload(:category)
    assert Repo.get_by(Category, description: "Doctors") == check.category
  end

  defp assert_amount_matches([amt, desc]) do
    assert amt == Repo.get_by(Transaction, description: desc).amount
  end

  defp assert_check_amount_matches([amt, desc]) do
    assert amt == Repo.get_by(Transaction, check_num: desc).amount
  end

  defp load_all_transactions_and_checks do
    1..3
    |> Enum.map(&(:ok = Importer.transactions("test/models/transactions_#{&1}.csv")))
    :ok = Importer.checks("test/models/checks.csv")
  end
end
