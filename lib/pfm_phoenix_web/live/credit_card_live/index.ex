defmodule PfmPhoenixWeb.CreditCardLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Finance
  alias PfmPhoenix.Finance.CreditCard

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :credit_cards, Finance.list_credit_cards(socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Credit card")
    |> assign(:credit_card, Finance.get_credit_card!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Credit card")
    |> assign(:credit_card, %CreditCard{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Credit cards")
    |> assign(:credit_card, nil)
  end

  @impl true
  def handle_info({PfmPhoenixWeb.CreditCardLive.FormComponent, {:saved, credit_card}}, socket) do
    {:noreply, stream_insert(socket, :credit_cards, credit_card)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    credit_card = Finance.get_credit_card!(id)
    {:ok, _} = Finance.delete_credit_card(credit_card)

    {:noreply, stream_delete(socket, :credit_cards, credit_card)}
  end
end