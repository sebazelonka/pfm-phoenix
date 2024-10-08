defmodule PfmPhoenix.TransactionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PfmPhoenix.Transactions` context.
  """

  @doc """
  Generate a transaction.
  """
  def transaction_fixture(attrs \\ %{}) do
    {:ok, transaction} =
      attrs
      |> Enum.into(%{
        amount: "120.5",
        category: "some category",
        date: ~D[2024-10-07],
        description: "some description",
        type: "some type"
      })
      |> PfmPhoenix.Transactions.create_transaction()

    transaction
  end
end
