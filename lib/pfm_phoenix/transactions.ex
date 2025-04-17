defmodule PfmPhoenix.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias PfmPhoenix.Repo

  alias PfmPhoenix.Transactions.Transaction

  @doc """
  Returns the list of transactions.

  ## Examples

      iex> list_transactions()
      [%Transaction{}, ...]

  """
  def list_transactions(user) do
    Transaction
    |> where(user_id: ^user.id)
    |> order_by([t], desc: t.date)
    |> Repo.all()
  end

  @doc """
  Returns a filtered list of transactions.

  ## Filters
  * start_date - Filter transactions by start date
  * end_date - Filter transactions by end date
  * type - Filter transactions by type (income/expense)
  * category - Filter transactions by category
  """
  def list_transactions(user, filters) do
    Transaction
    |> where(user_id: ^user.id)
    |> filter_by_date_range(filters)
    |> filter_by_type(filters)
    |> filter_by_category(filters)
    |> order_by([t], desc: t.date)
    |> Repo.all()
  end

  defp filter_by_date_range(query, %{start_date: start_date, end_date: end_date}) 
       when not is_nil(start_date) and not is_nil(end_date) do
    query |> where([t], t.date >= ^start_date and t.date <= ^end_date)
  end
  defp filter_by_date_range(query, %{start_date: start_date}) when not is_nil(start_date) do
    query |> where([t], t.date >= ^start_date)
  end
  defp filter_by_date_range(query, %{end_date: end_date}) when not is_nil(end_date) do
    query |> where([t], t.date <= ^end_date)
  end
  defp filter_by_date_range(query, _), do: query

  defp filter_by_type(query, %{type: type}) when not is_nil(type) and type != "" do
    type = String.to_existing_atom(type)
    query |> where([t], t.type == ^type)
  end
  defp filter_by_type(query, _), do: query

  defp filter_by_category(query, %{category: category}) when not is_nil(category) and category != "" do
    category = String.to_existing_atom(category)
    query |> where([t], t.category == ^category)
  end
  defp filter_by_category(query, _), do: query

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}, user) do
    attrs = Map.put(attrs, "user_id", user.id)

    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{data: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction, attrs \\ %{}) do
    Transaction.changeset(transaction, attrs)
  end
end
