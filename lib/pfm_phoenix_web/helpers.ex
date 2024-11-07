defmodule PfmPhoenixWeb.Helpers do
  def format_currency(amount) do
    Number.Currency.number_to_currency(amount, delimiter: ".", unit: "$")
  end

  def order_transactions(transactions) do
    transactions
    |> Enum.sort(fn tx1, tx2 ->
      # First compare by date
      date_comparison = Date.compare(tx1.date, tx2.date)

      case date_comparison do
        :eq ->
          # If dates are equal, compare by inserted_at
          DateTime.compare(tx1.inserted_at, tx2.inserted_at) in [:gt, :eq]

        :gt ->
          true

        :lt ->
          false
      end
    end)
  end
end
