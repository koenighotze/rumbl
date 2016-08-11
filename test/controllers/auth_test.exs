defmodule Rumbl.AuthTest do
  use Rumbl.ConnCase

  alias Rumbl.Auth


  setup do
    conn =
      conn
      |> bypass_through(Rumbl.Router, :browser)
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "auth halts if no current user", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])

    assert conn.halted
  end

  test "when a current user is set, the plug continues", %{conn: conn} do
    conn = Auth.authenticate_user(assign(conn, :current_user, %Rumbl.User{}), [])

    refute conn.halted
  end

end
