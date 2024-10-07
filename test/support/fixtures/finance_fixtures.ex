defmodule PfmPhoenix.FinanceFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PfmPhoenix.Finance` context.
  """

  @doc """
  Generate a budget.
  """
  def budget_fixture(attrs \\ %{}) do
    {:ok, budget} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> PfmPhoenix.Finance.create_budget()

    budget
  end
end
