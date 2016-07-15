defmodule Rumbl.Repo.Migrations.CreateBeard do
  use Ecto.Migration

  def change do
    create table(:beards) do
      add :url, :string
      add :name, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:beards, [:user_id])

  end
end
