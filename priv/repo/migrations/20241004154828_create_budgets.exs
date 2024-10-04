defmodule PfmPhoenix.Repo.Migrations.CreateBudgets do
  use Ecto.Migration

  def change do
    create table(:budgets) do
      add :name, :string
      add :description, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:budgets, [:user_id])
  end
end
