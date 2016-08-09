defmodule Rumbl.TestHelpers do

  alias Rumbl.Repo
  alias Rumbl.User

  @default_user %{username: "username", name: "name", password: "12345678"}

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(@default_user, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_beard(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:beards, attrs)
    |> Repo.insert!()
  end

end
