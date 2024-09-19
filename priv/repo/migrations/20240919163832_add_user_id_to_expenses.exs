defmodule PfmPhoenix.Repo.Migrations.AddUserIdToExpenses do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :user_id, references(:users, on_delete: :delete_all), null: true
    end

    create index(:expenses, [:user_id])
  end
end
