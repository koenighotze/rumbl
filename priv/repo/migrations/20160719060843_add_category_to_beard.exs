defmodule Rumbl.Repo.Migrations.AddCategoryToBeard do
  use Ecto.Migration

  def change do
    alter table(:beards) do
      add :category_id, references(:categories)
    end
  end
end
