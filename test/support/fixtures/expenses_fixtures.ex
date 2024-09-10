defmodule PfmPhoenix.ExpensesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PfmPhoenix.Expenses` context.
  """

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        category: "some category",
        date: ~D[2024-09-09],
        description: "some description"
      })
      |> PfmPhoenix.Expenses.create_expense()

    expense
  end
end
