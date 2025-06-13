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
    |> where([t], fragment("NOT EXISTS (SELECT 1 FROM transactions AS child WHERE child.parent_transaction_id = ?)", t.id))
    |> order_by([t], desc: t.date, desc: t.inserted_at, desc: t.id)
    |> Repo.all()
  end

  @doc """
  Returns a filtered list of transactions.

  ## Filters
  * start_date - Filter transactions by start date
  * end_date - Filter transactions by end date
  * type - Filter transactions by type (income/expense)
  * category - Filter transactions by category
  * sort_by - Sort order for transactions
  """
  def list_transactions(user, filters) do
    Transaction
    |> where(user_id: ^user.id)
    |> where([t], fragment("NOT EXISTS (SELECT 1 FROM transactions AS child WHERE child.parent_transaction_id = ?)", t.id))
    |> filter_by_date_range(filters)
    |> filter_by_type(filters)
    |> filter_by_category(filters)
    |> apply_sorting(filters)
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

  defp apply_sorting(query, %{sort_by: sort_by}) when not is_nil(sort_by) and sort_by != "" do
    case sort_by do
      "date_desc" -> query |> order_by([t], desc: t.date, desc: t.inserted_at, desc: t.id)
      "date_asc" -> query |> order_by([t], asc: t.date, desc: t.inserted_at, desc: t.id)
      "amount_desc" -> query |> order_by([t], desc: t.amount, desc: t.date, desc: t.inserted_at, desc: t.id)
      "amount_asc" -> query |> order_by([t], asc: t.amount, desc: t.date, desc: t.inserted_at, desc: t.id)
      "category_asc" -> query |> order_by([t], asc: t.category, desc: t.date, desc: t.inserted_at, desc: t.id)
      "category_desc" -> query |> order_by([t], desc: t.category, desc: t.date, desc: t.inserted_at, desc: t.id)
      "type_asc" -> query |> order_by([t], asc: t.type, desc: t.date, desc: t.inserted_at, desc: t.id)
      "type_desc" -> query |> order_by([t], desc: t.type, desc: t.date, desc: t.inserted_at, desc: t.id)
      _ -> query |> order_by([t], desc: t.date, desc: t.inserted_at, desc: t.id)
    end
  end
  defp apply_sorting(query, _), do: query |> order_by([t], desc: t.date, desc: t.inserted_at, desc: t.id)

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
  Gets a transaction for editing. If the transaction is an installment (has a parent),
  returns the parent transaction instead for proper editing workflow.

  ## Examples

      iex> get_transaction_for_edit!(installment_id)
      %Transaction{} # Returns parent transaction

      iex> get_transaction_for_edit!(regular_transaction_id)
      %Transaction{} # Returns the transaction itself

  """
  def get_transaction_for_edit!(id) do
    transaction = Repo.get!(Transaction, id)
    
    case transaction.parent_transaction_id do
      nil -> transaction
      parent_id -> Repo.get!(Transaction, parent_id)
    end
  end

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

  @doc """
  Creates a transaction with installments for credit card purchases.
  
  This will create the parent transaction and all child installment transactions.
  """
  def create_transaction_with_installments(attrs, user) do
    installments_count = Map.get(attrs, "installments_count")
    
    if installments_count && String.to_integer(installments_count) > 1 do
      create_installment_transactions(attrs, user)
    else
      create_transaction(attrs, user)
    end
  end

  defp create_installment_transactions(attrs, user) do
    installments_count = String.to_integer(attrs["installments_count"])
    total_amount = Decimal.new(attrs["amount"])
    installment_amount = Decimal.div(total_amount, installments_count)
    
    # Create parent transaction with divided amount
    parent_attrs = Map.merge(attrs, %{
      "amount" => Decimal.to_string(installment_amount),
      "user_id" => user.id,
      "installments_count" => installments_count,
      "installment_number" => 1
    })
    
    case Repo.insert(Transaction.changeset(%Transaction{}, parent_attrs)) do
      {:ok, parent_transaction} ->
        # Create child installment transactions
        child_transactions = create_child_installments(
          parent_transaction, 
          installment_amount, 
          installments_count, 
          attrs, 
          user
        )
        
        case child_transactions do
          {:ok, _transactions} -> {:ok, parent_transaction}
          {:error, _changeset} = error -> error
        end
        
      error -> error
    end
  end

  defp create_child_installments(parent_transaction, installment_amount, installments_count, attrs, user) do
    base_date = Date.from_iso8601!(attrs["date"])
    
    child_attrs_list = for installment_number <- 2..installments_count do
      installment_date = Date.add(base_date, (installment_number - 1) * 30) # Add 30 days for each installment
      
      %{
        "amount" => installment_amount,
        "description" => "#{attrs["description"]} (#{installment_number}/#{installments_count})",
        "date" => Date.to_iso8601(installment_date),
        "category" => attrs["category"],
        "type" => attrs["type"],
        "user_id" => user.id,
        "budget_id" => attrs["budget_id"],
        "credit_card_id" => attrs["credit_card_id"],
        "installments_count" => installments_count,
        "installment_number" => installment_number,
        "parent_transaction_id" => parent_transaction.id
      }
    end
    
    # Insert all child transactions one by one
    child_results = Enum.map(child_attrs_list, fn attrs ->
      %Transaction{}
      |> Transaction.changeset(attrs)
      |> Repo.insert()
    end)
    
    # Check if all insertions were successful
    if Enum.all?(child_results, fn {status, _} -> status == :ok end) do
      transactions = [parent_transaction | Enum.map(child_results, fn {:ok, tx} -> tx end)]
      {:ok, transactions}
    else
      {:error, :failed_to_create_installments}
    end
  end

  @doc """
  Gets all transactions for a specific credit card payment forecast.
  """
  def get_credit_card_forecast(user, credit_card_id) do
    from(t in Transaction,
      where: t.user_id == ^user.id and t.credit_card_id == ^credit_card_id,
      where: t.date >= ^Date.utc_today(),
      order_by: [asc: t.date]
    )
    |> Repo.all()
  end

  @doc """
  Gets upcoming payments grouped by month for forecasting.
  """
  def get_monthly_forecast(user, months_ahead \\ 12) do
    end_date = Date.add(Date.utc_today(), months_ahead * 30)
    
    from(t in Transaction,
      where: t.user_id == ^user.id,
      where: t.date >= ^Date.utc_today() and t.date <= ^end_date,
      where: not is_nil(t.installments_count),
      order_by: [asc: t.date]
    )
    |> Repo.all()
    |> Enum.group_by(fn transaction ->
      %{year: transaction.date.year, month: transaction.date.month}
    end)
  end
end
