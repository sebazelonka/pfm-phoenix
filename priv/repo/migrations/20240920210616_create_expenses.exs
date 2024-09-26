defmodule PfmPhoenix.Repo.Migrations.CreateExpenses do
  use Ecto.Migration

  def change do
    create table(:expenses) do
      add :amount, :decimal
      add :description, :string
      add :date, :date
      add :category, :string

      timestamps(type: :utc_datetime)
    end
  end
end
