defmodule Rumbl.RepoTest do
  use ExUnit.Case

  import Rumbl.Repo
  alias Rumbl.User

  @users [
    # :id, :name, :username, :password
    %User{id: 1, name: "David Schmitz", username: "ds", password: "geheim"},
    %User{id: 2, name: "Bratislav Metulski", username: "bm", password: "secret"},
    %User{id: 3, name: "Baguette Salami", username: "bs", password: "tressecret"}
  ]

  setup do
    @users
    |> Enum.each(fn user -> insert(user) end)

    on_exit fn ->
      delete_all(Rumbl.User)
    end

    :ok
  end



  test "fetch all users" do
    assert 0 < length(all(Rumbl.User))
  end

  test "get by id" do
    assert get(Rumbl.User, "1").name == "David Schmitz"
  end

  test "get by params" do
    assert get_by!(Rumbl.User, username: "bm").name == "Bratislav Metulski"
  end
end
