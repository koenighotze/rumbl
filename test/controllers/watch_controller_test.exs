defmodule Rumbl.WatchControllerTest do
  use Rumbl.ConnCase, async: true

  test "show shows the beard", %{conn: conn} do
    beard = insert_beard(insert_user(%{}), %{})

    conn =
      conn
      |> get(watch_path(conn, :show, beard))

    assert html_response(conn, 200) =~ beard.name
  end

end
