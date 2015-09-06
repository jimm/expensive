defmodule Expensive.TransactionTest do
  use Expensive.ModelCase

  alias Expensive.Transaction

  @valid_attrs %{amount: 42, day: 42, description: "some content", month: 42, notes: "some content", type: "some content", year: 42}
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
