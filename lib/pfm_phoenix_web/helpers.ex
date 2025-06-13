defmodule PfmPhoenixWeb.Helpers do
  def format_currency(amount) do
    Number.Currency.number_to_currency(amount, delimiter: ".", unit: "$")
  end

  def order_transactions(transactions) do
    transactions
    |> Enum.sort(fn tx1, tx2 ->
      # Sort by date descending, then by inserted_at descending, then by ID descending
      case Date.compare(tx1.date, tx2.date) do
        :gt -> true
        :lt -> false
        :eq ->
          case DateTime.compare(tx1.inserted_at, tx2.inserted_at) do
            :gt -> true
            :lt -> false
            :eq -> tx1.id > tx2.id
          end
      end
    end)
  end

  def format_installment_info(transaction) do
    cond do
      transaction.installment_number && transaction.installments_count ->
        if transaction.installment_number == transaction.installments_count do
          " (last payment)"
        else
          " (#{transaction.installment_number}/#{transaction.installments_count})"
        end
      true ->
        ""
    end
  end
end
