defmodule Expensive.CategoryTest do
  use Expensive.ModelCase

  alias Expensive.Category

  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "seeds loaded for tests" do
    assert Repo.get_by(Category, description: "Doctors")
  end
end
