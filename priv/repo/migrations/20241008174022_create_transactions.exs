defmodule PfmPhoenix.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :amount, :decimal
      add :description, :string
      add :date, :date
      add :category, :string
      add :type, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :budget_id, references(:budgets, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end
  end
end
