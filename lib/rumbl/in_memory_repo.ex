defmodule Rumbl.InMemoryRepo do
  @moduledoc """
  In memory repo
  """

  alias Rumbl.User

  def all(User) do
    [
      # :id, :name, :username, :password
      %User{id: "1", name: "David Schmitz", username: "ds", password: "geheim"},
      %User{id: "2", name: "Bratislav Metulski", username: "bm", password: "secret"},
      %User{id: "3", name: "Baguette Salami", username: "bs", password: "tressecret"}
    ]
  end

  def all(_m), do: []


  def get(User, id) do
    all(User)
    |> Enum.find(fn user -> user.id == id end)
  end

  def get(_, _), do: nil

  def get_by(module, params) do
    all(module)
    |> Enum.find(fn item -> Enum.all?(params, fn {key, value} -> Map.get(item, key) == value end) end )
  end
end
