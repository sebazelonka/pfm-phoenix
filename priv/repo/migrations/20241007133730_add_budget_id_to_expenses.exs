defmodule PfmPhoenix.Repo.Migrations.AddBudgetIdToExpenses do
  use Ecto.Migration

  def change do
    alter table(:expenses) do
      add :budget_id, references(:budgets, on_delete: :nothing)
    end
  end
end
