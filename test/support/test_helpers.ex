defmodule Rumbl.TestHelpers do
  import Ecto.Query

  alias Rumbl.Repo
  alias Rumbl.User

  @default_user %{username: "username", name: "name", password: "12345678"}
  @default_beard %{name: "name", url: "http://foo.bar/blub.com", description: "Whatever"}

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(@default_user, attrs)

    %User{}
    |> User.registration_changeset(changes)
    |> Repo.insert!()
  end

  def insert_beard(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:beards, Dict.merge(@default_beard, attrs))
    |> Repo.insert!()
  end

  def beard_count do
    Repo.one(from b in Rumbl.Beard, select: count(b.id))
  end
end
