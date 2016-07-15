defmodule Rumbl.BeardControllerTest do
  use Rumbl.ConnCase

  alias Rumbl.Beard
  @valid_attrs %{description: "some content", name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, beard_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing beards"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, beard_path(conn, :new)
    assert html_response(conn, 200) =~ "New beard"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, beard_path(conn, :create), beard: @valid_attrs
    assert redirected_to(conn) == beard_path(conn, :index)
    assert Repo.get_by(Beard, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, beard_path(conn, :create), beard: @invalid_attrs
    assert html_response(conn, 200) =~ "New beard"
  end

  test "shows chosen resource", %{conn: conn} do
    beard = Repo.insert! %Beard{}
    conn = get conn, beard_path(conn, :show, beard)
    assert html_response(conn, 200) =~ "Show beard"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, beard_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    beard = Repo.insert! %Beard{}
    conn = get conn, beard_path(conn, :edit, beard)
    assert html_response(conn, 200) =~ "Edit beard"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    beard = Repo.insert! %Beard{}
    conn = put conn, beard_path(conn, :update, beard), beard: @valid_attrs
    assert redirected_to(conn) == beard_path(conn, :show, beard)
    assert Repo.get_by(Beard, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    beard = Repo.insert! %Beard{}
    conn = put conn, beard_path(conn, :update, beard), beard: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit beard"
  end

  test "deletes chosen resource", %{conn: conn} do
    beard = Repo.insert! %Beard{}
    conn = delete conn, beard_path(conn, :delete, beard)
    assert redirected_to(conn) == beard_path(conn, :index)
    refute Repo.get(Beard, beard.id)
  end
end
