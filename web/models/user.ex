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

    has_many :beards, Rumbl.Beard

    timestamps
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, ~w(name username), [])
    |> validate_length(:username, min: 1, max: 20)
    |> validate_length(:name, min: 1, max: 5)
    |> unique_constraint(:username)
  end

  def registration_changeset(model, params \\ :empty) do
    model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 8, max: 20)
    |> put_pass_hash()
  end

  def put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pw}} -> put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pw))
      _ -> changeset
    end
  end

end
