defmodule PfmPhoenix.Repo.Migrations.AddBudgetIdToTransactions do
  use Ecto.Migration

  import Ecto.Query, warn: false

  alias PfmPhoenix.Repo
  alias PfmPhoenix.Accounts.User
  alias PfmPhoenix.Finance.Budget
  alias PfmPhoenix.Transactions.{Income, Expense}

  def up do
    # Start a transaction to ensure atomicity
    Repo.transaction(fn ->
      # Fetch all users
      Repo.all(User)
      |> Enum.each(&migrate_user_expenses_to_default_budget/1)
    end)
  end

  defp migrate_user_expenses_to_default_budget(user) do
    # Find or create the default budget for the user
    default_budget =
      Repo.get_by(Budget, user_id: user.id, name: "Default Budget") ||
        create_default_budget_for_user(user)

    # Update all expenses for the user to associate with the default budget
    from(e in Expense, where: e.user_id == ^user.id)
    |> Repo.update_all(set: [budget_id: default_budget.id])
  end

  defp create_default_budget_for_user(user) do
    %Budget{
      name: "Default Budget",
      description: "Automatically created default budget",
      user_id: user.id
    }
    |> Repo.insert!()
  end
end
