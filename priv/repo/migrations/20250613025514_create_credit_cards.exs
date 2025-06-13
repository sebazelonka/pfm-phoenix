defmodule PfmPhoenix.Repo.Migrations.CreateCreditCards do
  use Ecto.Migration

  def change do
    create table(:credit_cards) do
      add :name, :string, null: false
      add :limit, :decimal, precision: 15, scale: 2
      add :interest_rate, :decimal, precision: 5, scale: 2
      add :closing_date, :integer
      add :payment_due_date, :integer
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:credit_cards, [:user_id])
  end
end
