defmodule Rumbl.UserRepoTest do
  use Rumbl.ModelCase

  alias Rumbl.Repo
  alias Rumbl.User

  @valid_user %{username: "username", name: "name", password: "12345678"}

  test "usernames are unique" do
    insert_user(@valid_user)

    cs = User.changeset(%User{}, @valid_user)

    assert {:error, cs} = Repo.insert(cs)
    assert {:username, "has already been taken"} in cs.errors
  end

end
