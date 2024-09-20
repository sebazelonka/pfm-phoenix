defmodule PfmPhoenixWeb.ExpenseLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Transactions
  alias PfmPhoenix.Transactions.Expense

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :expenses, Transactions.list_expenses())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, Transactions.get_expense!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Expenses")
    |> assign(:expense, nil)
  end

  @impl true
  def handle_info({PfmPhoenixWeb.ExpenseLive.FormComponent, {:saved, expense}}, socket) do
    {:noreply, stream_insert(socket, :expenses, expense)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Transactions.get_expense!(id)
    {:ok, _} = Transactions.delete_expense(expense)

    {:noreply, stream_delete(socket, :expenses, expense)}
  end
end
