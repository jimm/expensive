defmodule Expensive.CheckControllerTest do
  use Expensive.ConnCase

  alias Expensive.Check
  @valid_attrs %{description: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, check_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing checks"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, check_path(conn, :new)
    assert html_response(conn, 200) =~ "New check"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, check_path(conn, :create), check: @valid_attrs
    assert redirected_to(conn) == check_path(conn, :index)
    assert Repo.get_by(Check, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, check_path(conn, :create), check: @invalid_attrs
    assert html_response(conn, 200) =~ "New check"
  end

  test "shows chosen resource", %{conn: conn} do
    check = Repo.insert! %Check{}
    conn = get conn, check_path(conn, :show, check)
    assert html_response(conn, 200) =~ "Show check"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, check_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    check = Repo.insert! %Check{}
    conn = get conn, check_path(conn, :edit, check)
    assert html_response(conn, 200) =~ "Edit check"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    check = Repo.insert! %Check{}
    conn = put conn, check_path(conn, :update, check), check: @valid_attrs
    assert redirected_to(conn) == check_path(conn, :show, check)
    assert Repo.get_by(Check, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    check = Repo.insert! %Check{}
    conn = put conn, check_path(conn, :update, check), check: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit check"
  end

  test "deletes chosen resource", %{conn: conn} do
    check = Repo.insert! %Check{}
    conn = delete conn, check_path(conn, :delete, check)
    assert redirected_to(conn) == check_path(conn, :index)
    refute Repo.get(Check, check.id)
  end
end
