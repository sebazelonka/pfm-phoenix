defmodule PfmPhoenixWeb.DashboardLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Transactions

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    transactions = Transactions.list_transactions(socket.assigns.current_user)

    # Get the 5 most recent transactions
    transactions =
      transactions
      |> Enum.sort(&(&1.date >= &2.date))
      |> Enum.take(5)

    # generate an array the sum of the amounts per category for the chart
    data =
      transactions
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
      |> assign(:chart_data, data)
      |> stream(:transactions, transactions)

    {:ok, socket}
  end
end
