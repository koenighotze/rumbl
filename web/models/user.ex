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

end
