defmodule PfmPhoenix.Finance do
  @moduledoc """
  The Finance context.
  """

  import Ecto.Query, warn: false
  alias PfmPhoenix.Repo

  alias PfmPhoenix.Finance.Budget
  alias PfmPhoenix.Finance.CreditCard

  @doc """
  Returns the list of budgets.

  ## Examples

      iex> list_budgets()
      [%Budget{}, ...]

  """

  def list_budgets(user) do
    Budget
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  @doc """
  Gets a single budget.

  Raises `Ecto.NoResultsError` if the Budget does not exist.

  ## Examples

      iex> get_budget!(123)
      %Budget{}

      iex> get_budget!(456)
      ** (Ecto.NoResultsError)

  """
  def get_budget!(id), do: Repo.get!(Budget, id)

  @doc """
  Creates a budget.

  ## Examples

      iex> create_budget(%{field: value})
      {:ok, %Budget{}}

      iex> create_budget(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_budget(attrs \\ %{}, user) do
    attrs = Map.put(attrs, "user_id", user.id)

    %Budget{}
    |> Budget.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a budget.

  ## Examples

      iex> update_budget(budget, %{field: new_value})
      {:ok, %Budget{}}

      iex> update_budget(budget, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_budget(%Budget{} = budget, attrs) do
    budget
    |> Budget.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a budget.

  ## Examples

      iex> delete_budget(budget)
      {:ok, %Budget{}}

      iex> delete_budget(budget)
      {:error, %Ecto.Changeset{}}

  """
  def delete_budget(%Budget{} = budget) do
    Repo.delete(budget)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking budget changes.

  ## Examples

      iex> change_budget(budget)
      %Ecto.Changeset{data: %Budget{}}

  """
  def change_budget(%Budget{} = budget, attrs \\ %{}) do
    Budget.changeset(budget, attrs)
  end

  # Credit Card functions

  def list_credit_cards(user) do
    CreditCard
    |> where(user_id: ^user.id)
    |> Repo.all()
  end

  def get_credit_card!(id), do: Repo.get!(CreditCard, id)

  def create_credit_card(attrs \\ %{}, user) do
    attrs = Map.put(attrs, "user_id", user.id)

    %CreditCard{}
    |> CreditCard.changeset(attrs)
    |> Repo.insert()
  end

  def update_credit_card(%CreditCard{} = credit_card, attrs) do
    credit_card
    |> CreditCard.changeset(attrs)
    |> Repo.update()
  end

  def delete_credit_card(%CreditCard{} = credit_card) do
    Repo.delete(credit_card)
  end

  def change_credit_card(%CreditCard{} = credit_card, attrs \\ %{}) do
    CreditCard.changeset(credit_card, attrs)
  end
end
