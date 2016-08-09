defmodule Rumbl.BeardControllerIntegrationTest do
  use Rumbl.ConnCase

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
end
