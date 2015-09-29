defmodule Expensive.TransactionTest do
  use Expensive.ModelCase

  alias Expensive.Transaction

  @valid_attrs %{amount: 42, day: 2, description: "some content", month: 8, notes: "some content", type: "some content", check_num: 1234, year: 2015}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Transaction.changeset(%Transaction{}, @invalid_attrs)
    refute changeset.valid?
  end
end
