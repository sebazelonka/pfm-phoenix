defmodule PfmPhoenix.Repo.Migrations.AddInstallmentsToTransactions do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :installments_count, :integer
      add :installment_number, :integer
      add :parent_transaction_id, references(:transactions, on_delete: :delete_all)
      add :credit_card_id, references(:credit_cards, on_delete: :nilify_all)
    end

    create index(:transactions, [:parent_transaction_id])
    create index(:transactions, [:credit_card_id])
  end
end
