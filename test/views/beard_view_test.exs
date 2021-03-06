defmodule Rumbl.BeardViewTest do
  use Rumbl.ConnCase, async: true

  import Phoenix.View

  alias Rumbl.Beard

  test "index.html is rendered if no beards are provided", %{conn: conn} do
    content = render_to_string(Rumbl.BeardView, "index.html", conn: conn, beards: [])

    assert String.contains?(content, "Listing beards")
  end

  test "index.html shows beard data", %{conn: conn} do
    beards = [
      %Beard{id: 1, name: "The Viking"},
      %Beard{id: 2, name: "The Hipster"}
    ]

    content = render_to_string(Rumbl.BeardView, "index.html", conn: conn, beards: beards)

    for beard <- beards do
      assert String.contains?(content, beard.name)
    end
  end

  test "new is rendered", %{conn: conn} do
    changeset = Beard.changeset(%Beard{})

    content = render_to_string(Rumbl.BeardView, "new.html", conn: conn, current_user: %Rumbl.User{username: "foo"}, categories: [], changeset: changeset)

    assert String.contains?(content, "Create a new beard for user")
  end

end
