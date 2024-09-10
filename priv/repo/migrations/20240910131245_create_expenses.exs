defmodule PfmPhoenix.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :amount, :decimal
      add :description, :text
      add :category, :text
      add :date, :date

      timestamps(type: :utc_datetime)
    end
  end
end
