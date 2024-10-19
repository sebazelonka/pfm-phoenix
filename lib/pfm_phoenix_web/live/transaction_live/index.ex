defmodule PfmPhoenixWeb.TransactionLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Finance
  alias PfmPhoenix.Transactions
  alias PfmPhoenix.Transactions.Transaction

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    transactions =
      Transactions.list_transactions(socket.assigns.current_user)
      |> Enum.sort(fn tx1, tx2 ->
        {tx1.date, tx1.inserted_at} >= {tx2.date, tx2.inserted_at}
      end)

    {:ok,
     socket
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(:budget, Finance.list_budgets(socket.assigns.current_user))
     |> stream(:transactions, transactions)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transaction")
    |> assign(:budgets, Finance.list_budgets(socket.assigns.current_user))
    |> assign(:transaction, Transactions.get_transaction!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transaction")
    |> assign(:budgets, Finance.list_budgets(socket.assigns.current_user))
    |> assign(:transaction, %Transaction{user_id: socket.assigns.current_user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transactions")
    |> assign(:transaction, nil)
  end

  @impl true
  def handle_info({PfmPhoenixWeb.TransactionLive.FormComponent, {:saved, transaction}}, socket) do
    {:noreply, stream_insert(socket, :transactions, transaction)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transaction = Transactions.get_transaction!(id)
    {:ok, _} = Transactions.delete_transaction(transaction)

    {:noreply, stream_delete(socket, :transactions, transaction)}
  end
end
