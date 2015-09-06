defmodule Expensive.CheckTest do
  use Expensive.ModelCase

  alias Expensive.Check

  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Check.changeset(%Check{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Check.changeset(%Check{}, @invalid_attrs)
    refute changeset.valid?
  end
end
