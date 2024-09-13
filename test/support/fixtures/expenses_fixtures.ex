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

  @doc """
  Generate a unique category title.
  """
  def unique_category_title, do: "some title#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        title: unique_category_title()
      })
      |> PfmPhoenix.Expenses.create_category()

    category
  end
end
