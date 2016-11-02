defmodule Rumbl.Beard do
  use Rumbl.Web, :model
  import Ecto.Changeset

  @primary_key {:id, Rumbl.Permalink, autogenerate: true}
  schema "beards" do
    field :url, :string
    field :name, :string
    field :description, :string
    field :slug, :string
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
    |> slugify_name
  end

  def slugify(str) do
    str
    |> String.downcase
    |> String.replace(~r{[^\w]+}, "-")
  end

  def slugify_name(changeset) do
    case changeset.changes do
      %{name: name} -> put_change(changeset, :slug, slugify(name))
      _ -> changeset
    end
  end

  defimpl Phoenix.Param, for: Rumbl.Beard do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
     end
  end


  defimpl String.Chars, for: Rumbl.Beard do
    def to_string(%Rumbl.Beard{id: id, name: name}) do
      "Beard: #{id} Name: #{name}"
    end
  end
end
