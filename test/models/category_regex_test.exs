defmodule Expensive.CategoryRegexTest do
  use Expensive.ModelCase

  alias Expensive.CategoryRegex
  alias Expensive.Category

  @valid_attrs %{regex: "some content", category_id: Repo.get_by(Category, description: "Doctors").id}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CategoryRegex.changeset(%CategoryRegex{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CategoryRegex.changeset(%CategoryRegex{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "finds matching" do
    cr = CategoryRegex.find_matching("doctors")
    assert nil != cr
    assert "Doctors" == Repo.get_by(Category, id: cr.category_id).description
  end

  test "finds another --- testing" do
    cr = CategoryRegex.find_matching("taxes education")
    assert nil != cr
    assert "Education" == Repo.get_by(Category, id: cr.category_id).description
  end

  test "returns nil if not found" do
    assert nil == CategoryRegex.find_matching("does not exist")
  end
end
