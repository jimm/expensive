defmodule Expensive.ImporterTest do
  use Expensive.ModelCase

  alias Expensive.Importer
  alias Expensive.Transaction
  alias Expensive.Check
  alias Expensive.Category

  test "load transactions, type 1" do
    assert :ok == Importer.transactions("test/models/transactions_1.csv")
    assert 5 == Repo.all(from t in Transaction, select: count(t.id)) |> hd
    [[-3202, "Food Store"], [-2509, "Gas Station"], [10000, "Deposit"],
     [-1234, "Some Check"], [-5545, "Check # 334"]]
    |> Enum.map(&assert_amount_matches/1)
  end

  test "load transactions, type 1, creates checks" do
    assert 0 = Repo.all(from c in Check, select: count(c.id)) |> hd
    assert :ok == Importer.transactions("test/models/transactions_1.csv")
    assert 2 = Repo.all(from c in Check, select: count(c.id)) |> hd
  end

  test "load transactions, type 2" do
    assert :ok == Importer.transactions("test/models/transactions_2.csv")
    assert 4 == Repo.all(from t in Transaction, select: count(t.id)) |> hd
    [[-8000, "A RESTAURANT"], [-1864, "ANOTHER RESTAURANT"],
     [-40003, "CHECK # 3387 REF # 017909492"], [10000, "DEPOSIT"]]
    |> Enum.map(&assert_amount_matches/1)
  end

  test "load transactions, type 3" do
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    assert 4 == Repo.all(from t in Transaction, select: count(t.id)) |> hd
    [[123456, "PAY"], [-9033, "MONTHLY BILL"]] |> Enum.map(&assert_amount_matches/1)
    [[-7500, 4182], [-17500, 4217]] |> Enum.map(&assert_check_amount_matches/1)
  end

  test "do not create duplicate transactions" do
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    assert 4 == Repo.all(from t in Transaction, select: count(t.id)) |> hd
  end

  test "load checks" do
    assert :ok == load_all_transactions_and_checks
    assert 6 == Repo.all(from c in Check, select: count(c.id)) |> hd
    assert Repo.get_by(Check, id: 3387)
  end

  test "link checks to transactions" do
    load_all_transactions_and_checks
    check = Repo.get_by(Check, id: 3387)
    assert nil != check.transaction_id
    txn = Repo.get_by(Transaction, id: check.transaction_id)
    assert txn.description =~ ~r{CHECK # 3387}
  end

  test "do not create duplicate checks" do
    assert :ok == load_all_transactions_and_checks
    assert :ok == Importer.checks("test/models/checks.csv")
    assert 6 == Repo.all(from c in Check, select: count(c.id)) |> hd
  end

  test "set categories" do
    load_all_transactions_and_checks
    check = Repo.get_by(Check, id: 4217) |> Repo.preload(:category)
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
