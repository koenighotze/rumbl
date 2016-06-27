defmodule Rumbl.User do
  # defstruct [:id, :name, :username, :password]

  use Rumbl.Web, :model

  schema "users" do
    # no need for an id field, it is added automatically

    field :name, :string
    field :username, :string
    # virtual fields are not persisted
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 20)
    |> validate_length(:name, min: 1, max: 5)
  end
end
