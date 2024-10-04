defmodule PfmPhoenixWeb.BudgetLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Finance
  alias PfmPhoenix.Finance.Budget

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:current_user, socket.assigns.current_user)
     |> stream(:budgets, Finance.list_budgets(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Budget")
    |> assign(:budget, Finance.get_budget!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Budget")
    |> assign(:budget, %Budget{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Budgets")
    |> assign(:budget, nil)
  end

  @impl true
  def handle_info({PfmPhoenixWeb.BudgetLive.FormComponent, {:saved, budget}}, socket) do
    {:noreply, stream_insert(socket, :budgets, budget)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    budget = Finance.get_budget!(id)
    {:ok, _} = Finance.delete_budget(budget)

    {:noreply, stream_delete(socket, :budgets, budget)}
  end
end
