defmodule Expensive.ImporterTest do
  use Expensive.ModelCase

  alias Expensive.Importer
  alias Expensive.Transaction
  alias Expensive.Check
  alias Expensive.Category

  test "load transactions, type 1" do
    assert :ok == Importer.transactions("test/models/transactions_1.csv")
    assert [3] == Repo.all(from t in Transaction, select: count(t.id))
    assert -3202 == Repo.get_by(Transaction, description: "Food Store").amount
    assert -2509 == Repo.get_by(Transaction, description: "Gas Station").amount
    assert 10000 == Repo.get_by(Transaction, description: "Deposit").amount
  end

  test "load transactions, type 2" do
    assert :ok == Importer.transactions("test/models/transactions_2.csv")
    assert [4] == Repo.all(from t in Transaction, select: count(t.id))
    assert  -8000 == Repo.get_by(Transaction, description: "A RESTAURANT").amount
    assert  -1864 == Repo.get_by(Transaction, description: "ANOTHER RESTAURANT").amount
    assert -40003 == Repo.get_by(Transaction, description: "CHECK # 3387 REF # 017909492").amount
    assert  10000 == Repo.get_by(Transaction, description: "DEPOSIT").amount
  end

  test "load transactions, type 3" do
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    assert [4] == Repo.all(from t in Transaction, select: count(t.id))
    assert 123456 == Repo.get_by(Transaction, description: "PAY").amount
    assert  -9033 == Repo.get_by(Transaction, description: "MONTHLY BILL").amount
    assert  -7500 == Repo.get_by(Transaction, check_num: 4182).amount
    assert -17500 == Repo.get_by(Transaction, check_num: 4217).amount
  end

  test "load checks" do
    assert :ok == load_all_transactions_and_checks
    assert [4] == Repo.all(from c in Check, select: count(c.id))
    assert Repo.get_by(Check, id: 3387)
  end

  test "link checks to transactions" do
    load_all_transactions_and_checks
    check = Repo.get_by(Check, id: 3387)
    assert nil != check.transaction_id
    txn = Repo.get_by(Transaction, id: check.transaction_id)
    assert txn.description =~ ~r{CHECK # 3387}
  end

  test "set categories" do
    load_all_transactions_and_checks
    check = Repo.get_by(Check, id: 4217)
    assert Repo.get_by(Category, description: "Doctors").id == check.category_id
  end

  defp load_all_transactions_and_checks do
    1..3
    |> Enum.map(&(:ok == Importer.transactions("test/models/transactions_#{&1}.csv")))
    Importer.checks("test/models/checks.csv")
  end
end
