defmodule Expensive.CategoryRegexTest do
  use Expensive.ModelCase

  alias Expensive.CategoryRegex

  @valid_attrs %{regex: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CategoryRegex.changeset(%CategoryRegex{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CategoryRegex.changeset(%CategoryRegex{}, @invalid_attrs)
    refute changeset.valid?
  end
end
