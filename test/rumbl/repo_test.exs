defmodule Rumbl.RepoTest do
  use ExUnit.Case

  import Ecto.Query, only: [from: 2]

  alias Rumbl.Repo
  alias Rumbl.User
  alias Ecto.UUID

  @users [
    # :id, :name, :username, :password
    %User{name: "David Schmitz", username: UUID.generate, password: "geheim"},
    %User{name: "Bratislav Metulski", username: UUID.generate, password: "secret"},
    %User{name: "Baguette Salami", username: UUID.generate, password: "tressecret"}
  ]

  setup do
    @users
    |> Enum.each(fn user -> Repo.insert(user) end)

    on_exit fn ->
      users_to_delete = @users |> Enum.map(fn user -> Map.delete(user, :password) end)

      Repo.delete_all(Rumbl.User, users_to_delete)
    end

    :ok
  end

  test "fetch all users" do
    assert 0 < length(Repo.all(Rumbl.User))
  end

  test "get by id" do
    # any_user = Repo.all(from u in User, where: not(is_nil(u.id))) |> Enum.take(1)
    any_user = Repo.one(from u in User, limit: 1)
    assert Repo.get(Rumbl.User, any_user.id).name == any_user.name
  end

  test "get by params" do
    assert Repo.get_by!(Rumbl.User, name: "David Schmitz").username != ""
  end
end
