defmodule Rumbl.Repo.Migrations.AddSlugToBeard do
  use Ecto.Migration

  def change do
    alter table(:beards) do
      add :slug, :string
    end
  end
end
