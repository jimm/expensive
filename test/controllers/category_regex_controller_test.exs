defmodule Expensive.CategoryRegexControllerTest do
  use Expensive.ConnCase

  alias Expensive.Category
  alias Expensive.CategoryRegex

  @valid_attrs %{regex: "some content", category_id: Repo.get_by(Category, description: "Doctors").id}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, category_regex_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing category regexes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, category_regex_path(conn, :new)
    assert html_response(conn, 200) =~ "New category regex"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, category_regex_path(conn, :create), category_regex: @valid_attrs
    assert redirected_to(conn) == category_regex_path(conn, :index)
    assert Repo.get_by(CategoryRegex, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, category_regex_path(conn, :create), category_regex: @invalid_attrs
    assert html_response(conn, 200) =~ "New category regex"
  end

  test "shows chosen resource", %{conn: conn} do
    category_regex = Repo.insert! %CategoryRegex{}
    conn = get conn, category_regex_path(conn, :show, category_regex)
    assert html_response(conn, 200) =~ "Show category regex"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, category_regex_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    category_regex = Repo.insert! %CategoryRegex{}
    conn = get conn, category_regex_path(conn, :edit, category_regex)
    assert html_response(conn, 200) =~ "Edit category regex"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    category_regex = Repo.insert! %CategoryRegex{}
    conn = put conn, category_regex_path(conn, :update, category_regex), category_regex: @valid_attrs
    assert redirected_to(conn) == category_regex_path(conn, :show, category_regex)
    assert Repo.get_by(CategoryRegex, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    category_regex = Repo.insert! %CategoryRegex{}
    conn = put conn, category_regex_path(conn, :update, category_regex), category_regex: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit category regex"
  end

  test "deletes chosen resource", %{conn: conn} do
    category_regex = Repo.insert! %CategoryRegex{}
    conn = delete conn, category_regex_path(conn, :delete, category_regex)
    assert redirected_to(conn) == category_regex_path(conn, :index)
    refute Repo.get(CategoryRegex, category_regex.id)
  end
end
