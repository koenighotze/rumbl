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

  test "an auth. user is added to the session", %{conn: conn} do
    conn =
      conn
      |> Auth.login(%Rumbl.User{id: "123"})
      |> send_resp(:ok, "")

    id =
      conn
      |> get("/")
      |> get_session(:user_id)

    assert id == "123"
  end

  test "after logut the user is removed from the session", %{conn: conn} do
    conn =
      conn
      |> Auth.login(%Rumbl.User{id: "123"})
      |> Auth.logout()
      |> send_resp(:ok, "")

    id = conn
      |> get("/")
      |> get_session(:user_id)

    refute id
  end

  test "call loads a user by the given user id", %{conn: conn} do
    user = insert_user(%{})

    conn =
      conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Rumbl.Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "call uses a current user if set", %{conn: conn} do
    user = %Rumbl.User{id: "123"}

    conn =
      conn
      |> assign(:current_user, user)
      |> Auth.call(Rumbl.Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "call halts if neither a user is set nor an id is provided", %{conn: conn} do
    conn =
      conn
      |> Auth.call(Rumbl.Repo)

    refute conn.assigns.current_user
  end

  test "valid login", %{conn: conn} do
    user = insert_user(%{ username: "abcdef", password: "12345678" })

    {:ok, conn} =
      conn
      |> Auth.login_by_username_and_password(user.username, user.password, repo: Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "no such user", %{conn: conn} do
    assert {:error, :not_found, _} =
      conn
      |> Auth.login_by_username_and_password("foo", "bar", repo: Repo)
  end

  test "wrong password", %{conn: conn} do
    user = insert_user(%{ username: "abcdef", password: "12345678" })

    assert {:error, :unauthorized, _} =
      conn
      |> Auth.login_by_username_and_password(user.username, "wrongpassword", repo: Repo)
  end
end
