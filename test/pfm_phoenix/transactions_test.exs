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

  describe "incomes" do
    alias PfmPhoenix.Transactions.Income

    import PfmPhoenix.TransactionsFixtures

    @invalid_attrs %{date: nil, description: nil, category: nil, amount: nil}

    test "list_incomes/0 returns all incomes" do
      income = income_fixture()
      assert Transactions.list_incomes() == [income]
    end

    test "get_income!/1 returns the income with given id" do
      income = income_fixture()
      assert Transactions.get_income!(income.id) == income
    end

    test "create_income/1 with valid data creates a income" do
      valid_attrs = %{date: ~D[2024-09-22], description: "some description", category: "some category", amount: "120.5"}

      assert {:ok, %Income{} = income} = Transactions.create_income(valid_attrs)
      assert income.date == ~D[2024-09-22]
      assert income.description == "some description"
      assert income.category == "some category"
      assert income.amount == Decimal.new("120.5")
    end

    test "create_income/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_income(@invalid_attrs)
    end

    test "update_income/2 with valid data updates the income" do
      income = income_fixture()
      update_attrs = %{date: ~D[2024-09-23], description: "some updated description", category: "some updated category", amount: "456.7"}

      assert {:ok, %Income{} = income} = Transactions.update_income(income, update_attrs)
      assert income.date == ~D[2024-09-23]
      assert income.description == "some updated description"
      assert income.category == "some updated category"
      assert income.amount == Decimal.new("456.7")
    end

    test "update_income/2 with invalid data returns error changeset" do
      income = income_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_income(income, @invalid_attrs)
      assert income == Transactions.get_income!(income.id)
    end

    test "delete_income/1 deletes the income" do
      income = income_fixture()
      assert {:ok, %Income{}} = Transactions.delete_income(income)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_income!(income.id) end
    end

    test "change_income/1 returns a income changeset" do
      income = income_fixture()
      assert %Ecto.Changeset{} = Transactions.change_income(income)
    end
  end

  describe "transactions" do
    alias PfmPhoenix.Transactions.Transaction

    import PfmPhoenix.TransactionsFixtures

    @invalid_attrs %{type: nil, date: nil, description: nil, category: nil, amount: nil}

    test "list_transactions/0 returns all transactions" do
      transaction = transaction_fixture()
      assert Transactions.list_transactions() == [transaction]
    end

    test "get_transaction!/1 returns the transaction with given id" do
      transaction = transaction_fixture()
      assert Transactions.get_transaction!(transaction.id) == transaction
    end

    test "create_transaction/1 with valid data creates a transaction" do
      valid_attrs = %{type: "some type", date: ~D[2024-10-07], description: "some description", category: "some category", amount: "120.5"}

      assert {:ok, %Transaction{} = transaction} = Transactions.create_transaction(valid_attrs)
      assert transaction.type == "some type"
      assert transaction.date == ~D[2024-10-07]
      assert transaction.description == "some description"
      assert transaction.category == "some category"
      assert transaction.amount == Decimal.new("120.5")
    end

    test "create_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_transaction(@invalid_attrs)
    end

    test "update_transaction/2 with valid data updates the transaction" do
      transaction = transaction_fixture()
      update_attrs = %{type: "some updated type", date: ~D[2024-10-08], description: "some updated description", category: "some updated category", amount: "456.7"}

      assert {:ok, %Transaction{} = transaction} = Transactions.update_transaction(transaction, update_attrs)
      assert transaction.type == "some updated type"
      assert transaction.date == ~D[2024-10-08]
      assert transaction.description == "some updated description"
      assert transaction.category == "some updated category"
      assert transaction.amount == Decimal.new("456.7")
    end

    test "update_transaction/2 with invalid data returns error changeset" do
      transaction = transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_transaction(transaction, @invalid_attrs)
      assert transaction == Transactions.get_transaction!(transaction.id)
    end

    test "delete_transaction/1 deletes the transaction" do
      transaction = transaction_fixture()
      assert {:ok, %Transaction{}} = Transactions.delete_transaction(transaction)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_transaction!(transaction.id) end
    end

    test "change_transaction/1 returns a transaction changeset" do
      transaction = transaction_fixture()
      assert %Ecto.Changeset{} = Transactions.change_transaction(transaction)
    end
  end
end
