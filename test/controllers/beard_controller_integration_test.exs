defmodule Rumbl.BeardControllerIntegrationTest do
  use Rumbl.ConnCase

  alias Rumbl.{Beard, Repo}

  @valid_beard %{url: "http://foo.bar.baz", name: "The Lodbrok", description: "Crazy Viking"}
  @invalid_beard %{}

  test "user must be authenticated", %{conn: conn} do
    conns = [
      get(conn, beard_path(conn, :new)),
      get(conn, beard_path(conn, :index)),
      get(conn, beard_path(conn, :show, "123")),
      get(conn, beard_path(conn, :edit, "123")),
      get(conn, beard_path(conn, :delete, "123")),
      get(conn, beard_path(conn, :create, %{})),
      get(conn, beard_path(conn, :update, "123", %{}))
    ]

    Enum.each(conns, fn conn ->
      assert html_response(conn, 302) # assert redirect
      assert conn.halted
    end)
  end

  @tag login_as: "max"
  test "authenticated users can see their beard", %{conn: conn, user: user} do
    insert_beard(user, name: "The Lodbrok")

    conn = get(conn, beard_path(conn, :index))

    assert html_response(conn, 200) =~ "The Lodbrok"
  end

  @tag login_as: "max"
  test "authenticated users cannot see other user's beards", %{conn: conn} do
    insert_beard(insert_user(username: "Hotzenplotz"), name: "The Lodbrok")

    conn = get(conn, beard_path(conn, :index))

    refute String.contains?(html_response(conn, 200), "The Lodbrok")
  end

  @tag login_as: "max"
  test "beards are created and then redirected to", %{conn: conn, user: user} do
    conn = post conn, beard_path(conn, :create), beard: @valid_beard
    assert redirected_to(conn) == beard_path(conn, :index)

    assert Repo.get_by(Beard, @valid_beard).user_id == user.id
  end

  @tag login_as: "max"
  test "invalid beards are not created", %{conn: conn} do
    beard_count_before = beard_count

    conn = post conn, beard_path(conn, :create), beard: @invalid_beard
    assert html_response(conn, 200) =~ "error"
    assert beard_count_before == beard_count
  end

  @tag login_as: "max"
  test "users cannot access other peoples beards", %{conn: conn} do
    other_user = insert_user(username: "SomeoneElse")
    beard = insert_beard(other_user, name: "The Lodbrok")

    assert_error_sent :not_found, fn ->
      get(conn, beard_path(conn, :show, beard))
    end

    assert_error_sent :not_found, fn ->
      get(conn, beard_path(conn, :delete, beard))
    end

    assert_error_sent :not_found, fn ->
      get(conn, beard_path(conn, :edit, beard))
    end

    assert_error_sent :not_found, fn ->
      get(conn, beard_path(conn, :update, beard))
    end
  end

end
