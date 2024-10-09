defmodule PfmPhoenix.Repo.Migrations.MigrateExpensesAndIncomesToTransactionsTable do
  use Ecto.Migration

  import Ecto.Query

  def up do
    execute """
    INSERT INTO transactions (amount, description, date, category, type, user_id, budget_id, inserted_at, updated_at)
    SELECT amount, description, date, category, 'expense', user_id, budget_id, inserted_at, updated_at
    FROM expenses
    """
  end
end
