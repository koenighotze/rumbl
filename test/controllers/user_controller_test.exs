defmodule Rumbl.UserControllerTest do
  use Rumbl.ConnCase

  test "users cannot be viewed if not authenticated", %{conn: conn} do
    conn = get(conn, user_path(conn, :index))
    assert html_response(conn, 302)
    assert conn.halted
  end

  test "users can be viewed if authenticated" do
    user = insert_user(username: "Hotzenplotz")

    conn = conn
    |> assign(:current_user, user)
    |> get(user_path(conn, :index))

    assert html_response(conn, 200)
  end

end
