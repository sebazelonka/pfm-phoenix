defmodule PfmPhoenix.Repo.Migrations.RemoveIncomeExpensesAndCategoriesTables do
  use Ecto.Migration

  def up do
    drop table(:expenses)
    drop table(:incomes)
    drop table(:categories)
  end
end
