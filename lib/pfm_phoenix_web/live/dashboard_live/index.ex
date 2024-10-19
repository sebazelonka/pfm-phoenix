defmodule PfmPhoenixWeb.DashboardLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Transactions
  alias PfmPhoenix.Finance

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
      |> assign(:budgets, Finance.list_budgets(socket.assigns.current_user))
      |> assign(:chart_data, chart_data)
      |> stream(:transactions_table, transactions_table)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:budgets, Finance.list_budgets(socket.assigns.current_user))
    |> assign(:transaction, PfmPhoenix.Transactions.get_transaction!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:budgets, Finance.list_budgets(socket.assigns.current_user))
    |> assign(:transaction, %PfmPhoenix.Transactions.Transaction{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Dashboard")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_info({PfmPhoenixWeb.TransactionLive.FormComponent, {:saved, _transaction}}, socket) do
    # Fetch all transactions for the current user
    transactions = Transactions.list_transactions(socket.assigns.current_user)

    # Update transactions_table stream
    updated_transactions =
      transactions
      |> Enum.sort(fn tx1, tx2 ->
        {tx1.date, tx1.inserted_at} >= {tx2.date, tx2.inserted_at}
      end)
      |> Enum.take(5)

    # Update chart_data
    updated_chart_data =
      transactions
      |> Enum.filter(fn transaction -> transaction.type != :income end)
      |> Enum.group_by(fn transaction -> transaction.category end)
      |> Enum.map(fn {category, items} ->
        total_amount =
          items
          |> Enum.reduce(0, fn item, acc ->
            amount = Decimal.to_float(item.amount)
            acc + amount
          end)

        %{id: category, label: category, value: total_amount}
      end)

    socket =
      socket
      |> stream(:transactions_table, updated_transactions, reset: true)
      |> assign(:chart_data, updated_chart_data)

    IO.inspect(socket, label: "Socket after update")
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    # Update both the stream and the chart data after deletion
    transactions = Transactions.list_transactions(socket.assigns.current_user)

    updated_transactions =
      transactions
      |> Enum.sort(fn tx1, tx2 ->
        {tx1.date, tx1.inserted_at} >= {tx2.date, tx2.inserted_at}
      end)
      |> Enum.take(5)

    updated_chart_data =
      transactions
      |> Enum.filter(fn transaction -> transaction.type != :income end)
      |> Enum.group_by(fn transaction -> transaction.category end)
      |> Enum.map(fn {category, items} ->
        total_amount =
          items
          |> Enum.reduce(0, fn item, acc ->
            amount = Decimal.to_float(item.amount)
            acc + amount
          end)

        %{id: category, label: category, value: total_amount}
      end)

    socket =
      socket
      |> stream(:transactions_table, updated_transactions, reset: true)
      |> assign(:chart_data, updated_chart_data)

    {:noreply, socket}
  end
end
