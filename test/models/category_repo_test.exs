defmodule Rumbl.CategoryRepoTest do
  use Rumbl.ModelCase

  alias Rumbl.Repo
  alias Rumbl.Category

  test "alphabetical returns the categories in alpha order" do
    Repo.insert!(%Category{name: "b"})
    Repo.insert!(%Category{name: "c"})
    Repo.insert!(%Category{name: "a"})

    res =
      Category
      |> Category.alphabetical()
      |> Repo.all
      |> Enum.map(fn cat -> cat.name end)

    assert ~w(a b c) == res
  end

  test "names and ids returns the name and id" do
    Repo.insert!(%Category{name: "b"})
    Repo.insert!(%Category{name: "c"})
    Repo.insert!(%Category{name: "a"})

    res =
      Category
      |> Category.names_and_ids
      |> Repo.all

    for item <- res do
      {name, id} = item
      assert is_integer(id)
      assert name =~ ~r/[abc]/
    end

  end

end
