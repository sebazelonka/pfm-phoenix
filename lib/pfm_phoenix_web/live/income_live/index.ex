defmodule PfmPhoenixWeb.IncomeLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Transactions
  alias PfmPhoenix.Transactions.Income

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user, label: "current_user")
    {:ok, stream(socket, :incomes, Transactions.list_incomes(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Income")
    |> assign(:income, Transactions.get_income!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Income")
    |> assign(:income, %Income{user_id: socket.assigns.current_user.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Incomes")
    |> assign(:income, nil)
  end

  @impl true
  def handle_info({PfmPhoenixWeb.IncomeLive.FormComponent, {:saved, income}}, socket) do
    {:noreply, stream_insert(socket, :incomes, income)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    income = Transactions.get_income!(id)
    {:ok, _} = Transactions.delete_income(income)

    {:noreply, stream_delete(socket, :incomes, income)}
  end
end
