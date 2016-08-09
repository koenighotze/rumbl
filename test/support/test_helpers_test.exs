defmodule Rumbl.TestHelpersTest do
  use ExUnit.Case
  import Rumbl.TestHelpers

  setup do
    # must do this here, because the conn_case is not available yet
    Ecto.Adapters.SQL.restart_test_transaction(Rumbl.Repo, [])
    :ok
  end

  test "users can be inserted" do
    user = insert_user(%{username: "max", name: "blah", password: "12345678"})
    assert user.username == "max"
    assert user.id > 0
  end

  test "beards can be inserted" do
    user = insert_user(%{username: "max", name: "blah", password: "12345678"})
    beard = insert_beard(user, name: "The Viking")

    assert beard.id > 0
  end

end
