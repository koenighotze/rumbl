defmodule Rumbl.Category do
  use Rumbl.Web, :model

  schema "categories" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()


  def alphabetical(query) do
    from q in query, order_by: q.name
  end

  def names_and_ids(query) do
    from q in query, select: {q.name, q.id}
  end

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
  end
end
