defmodule Rumbl.BeardTest do
  use Rumbl.ModelCase

  alias Rumbl.Beard

  @valid_attrs %{description: "some content", name: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Beard.changeset(%Beard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Beard.changeset(%Beard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
