defmodule PfmPhoenixWeb.CreditCardLive.Show do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Finance

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:credit_card, Finance.get_credit_card!(id))}
  end

  defp page_title(:show), do: "Show Credit card"
  defp page_title(:edit), do: "Edit Credit card"
end