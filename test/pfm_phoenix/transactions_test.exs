defmodule PfmPhoenix.TransactionsTest do
  use PfmPhoenix.DataCase

  alias PfmPhoenix.Transactions

  describe "expenses" do
    alias PfmPhoenix.Transactions.Expense

    import PfmPhoenix.TransactionsFixtures

    @invalid_attrs %{date: nil, description: nil, category: nil, amount: nil}

    test "list_expenses/0 returns all expenses" do
      expense = expense_fixture()
      assert Transactions.list_expenses() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Transactions.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{date: ~D[2024-09-19], description: "some description", category: "some category", amount: "120.5"}

      assert {:ok, %Expense{} = expense} = Transactions.create_expense(valid_attrs)
      assert expense.date == ~D[2024-09-19]
      assert expense.description == "some description"
      assert expense.category == "some category"
      assert expense.amount == Decimal.new("120.5")
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{date: ~D[2024-09-20], description: "some updated description", category: "some updated category", amount: "456.7"}

      assert {:ok, %Expense{} = expense} = Transactions.update_expense(expense, update_attrs)
      assert expense.date == ~D[2024-09-20]
      assert expense.description == "some updated description"
      assert expense.category == "some updated category"
      assert expense.amount == Decimal.new("456.7")
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_expense(expense, @invalid_attrs)
      assert expense == Transactions.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Transactions.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Transactions.change_expense(expense)
    end
  end
end
