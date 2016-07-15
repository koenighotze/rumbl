defmodule Rumbl.Beard do
  use Rumbl.Web, :model

  schema "beards" do
    field :url, :string
    field :name, :string
    field :description, :string
    belongs_to :user, Rumbl.User

    timestamps
  end

  @required_fields ~w(url name description)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
