defmodule PfmPhoenix.Repo.Migrations.CreateIncomes do
  use Ecto.Migration

  def change do
    create table(:incomes) do
      add :amount, :decimal
      add :description, :string
      add :date, :date
      add :category, :string

      timestamps(type: :utc_datetime)
    end
  end
end
