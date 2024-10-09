defmodule PfmPhoenixWeb.DashboardLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Transactions

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    transactions = Transactions.list_transactions(socket.assigns.current_user)

    # Get the 5 most recent transactions
    transactions_table =
      transactions
      |> Enum.sort(fn tx1, tx2 ->
        {tx1.date, tx1.inserted_at} >= {tx2.date, tx2.inserted_at}
      end)
      |> Enum.take(5)

    # generate an array the sum of the expenses amount per category for the chart
    chart_data =
      transactions
      # Remove income transactions
      |> Enum.filter(fn transaction -> transaction.type != :income end)
      |> Enum.group_by(fn transaction -> transaction.category end)
      |> Enum.map(fn {category, items} ->
        total_amount =
          items
          |> Enum.reduce(0, fn item, acc ->
            # Convert the Decimal to float and sum the amounts
            amount = Decimal.to_float(item.amount)
            acc + amount
          end)

        # Return a map with the category and total amount
        %{id: category, label: category, value: total_amount}
      end)

    socket =
      socket
      |> assign(:current_user, socket.assigns.current_user)
      |> assign(:chart_data, chart_data)
      |> stream(:transactions_table, transactions_table)

    {:ok, socket}
  end
end
