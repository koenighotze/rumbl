defmodule Rumbl.Beard do
  use Rumbl.Web, :model
  import Ecto.Changeset

  schema "beards" do
    field :url, :string
    field :name, :string
    field :description, :string
    belongs_to :user, Rumbl.User

    belongs_to :category, Rumbl.Category

    timestamps
  end

  @required_fields ~w(url name description)
  @optional_fields ~w(category_id)


  def with_category(query) do
    from b in query, preload: [:category]
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 1, max: 20)
    |> assoc_constraint(:category)
  end

  defimpl String.Chars, for: Rumbl.Beard do
    def to_string(%Rumbl.Beard{id: id, name: name}) do
      "Beard: #{id} Name: #{name}"
    end
  end
end
