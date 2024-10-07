defmodule PfmPhoenixWeb.ExpenseLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Finance
  alias PfmPhoenix.Transactions
  alias PfmPhoenix.Transactions.Expense

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(:budget, Finance.list_budgets(socket.assigns.current_user))
     |> stream(:expenses, Transactions.list_expenses(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, Transactions.get_expense!(id))
    |> assign(:budgets, Finance.list_budgets(socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{user_id: socket.assigns.current_user.id})
    |> assign(:budgets, Finance.list_budgets(socket.assigns.current_user))
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
