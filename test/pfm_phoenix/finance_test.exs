defmodule PfmPhoenix.FinanceTest do
  use PfmPhoenix.DataCase

  alias PfmPhoenix.Finance

  describe "budgets" do
    alias PfmPhoenix.Finance.Budget

    import PfmPhoenix.FinanceFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_budgets/0 returns all budgets" do
      budget = budget_fixture()
      assert Finance.list_budgets() == [budget]
    end

    test "get_budget!/1 returns the budget with given id" do
      budget = budget_fixture()
      assert Finance.get_budget!(budget.id) == budget
    end

    test "create_budget/1 with valid data creates a budget" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Budget{} = budget} = Finance.create_budget(valid_attrs)
      assert budget.name == "some name"
      assert budget.description == "some description"
    end

    test "create_budget/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Finance.create_budget(@invalid_attrs)
    end

    test "update_budget/2 with valid data updates the budget" do
      budget = budget_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Budget{} = budget} = Finance.update_budget(budget, update_attrs)
      assert budget.name == "some updated name"
      assert budget.description == "some updated description"
    end

    test "update_budget/2 with invalid data returns error changeset" do
      budget = budget_fixture()
      assert {:error, %Ecto.Changeset{}} = Finance.update_budget(budget, @invalid_attrs)
      assert budget == Finance.get_budget!(budget.id)
    end

    test "delete_budget/1 deletes the budget" do
      budget = budget_fixture()
      assert {:ok, %Budget{}} = Finance.delete_budget(budget)
      assert_raise Ecto.NoResultsError, fn -> Finance.get_budget!(budget.id) end
    end

    test "change_budget/1 returns a budget changeset" do
      budget = budget_fixture()
      assert %Ecto.Changeset{} = Finance.change_budget(budget)
    end
  end
end
