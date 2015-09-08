defmodule Expensive.ImporterTest do
  use Expensive.ModelCase

  alias Expensive.Importer
  alias Expensive.Transaction
  # alias Expensive.Check

  test "load transactions, type 1" do
    assert :ok == Importer.transactions("test/models/transactions_1.csv")
    # TODO
    # assert 2 == Transaction.count
  end

  test "load transactions, type 2" do
    assert :ok == Importer.transactions("test/models/transactions_2.csv")
    # TODO
    # assert 3 == Transaction.count
  end

  test "load transactions, type 3" do
    assert :ok == Importer.transactions("test/models/transactions_3.csv")
    # TODO
    # assert 4 == Transaction.count
  end
end
