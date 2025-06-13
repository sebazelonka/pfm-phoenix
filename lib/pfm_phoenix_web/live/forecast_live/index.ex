defmodule PfmPhoenixWeb.ForecastLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Transactions
  alias PfmPhoenix.Finance

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    monthly_forecast = Transactions.get_monthly_forecast(socket.assigns.current_user)
    credit_cards = Finance.list_credit_cards(socket.assigns.current_user)

    socket =
      socket
      |> assign(:monthly_forecast, monthly_forecast)
      |> assign(:credit_cards, credit_cards)
      |> assign(:selected_months, generate_next_months(12))
      |> assign(:selected_credit_card_id, "")

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Payment Forecast")
  end

  @impl true
  def handle_event("filter_by_credit_card", %{"credit_card_id" => credit_card_id}, socket) do
    forecast = if credit_card_id == "" do
      Transactions.get_monthly_forecast(socket.assigns.current_user)
    else
      credit_card_id = String.to_integer(credit_card_id)
      Transactions.get_credit_card_forecast(socket.assigns.current_user, credit_card_id)
      |> Enum.group_by(fn transaction ->
        %{year: transaction.date.year, month: transaction.date.month}
      end)
    end

    {:noreply, 
     socket
     |> assign(:monthly_forecast, forecast)
     |> assign(:selected_credit_card_id, credit_card_id)}
  end

  defp generate_next_months(count) do
    today = Date.utc_today()
    
    Enum.map(0..(count - 1), fn month_offset ->
      date = Date.add(today, month_offset * 30)
      %{
        year: date.year,
        month: date.month,
        name: Calendar.strftime(date, "%B %Y")
      }
    end)
  end

  defp get_month_total(forecast, year, month) do
    case Map.get(forecast, %{year: year, month: month}) do
      nil -> Decimal.new(0)
      transactions ->
        transactions
        |> Enum.reduce(Decimal.new(0), fn transaction, acc ->
          Decimal.add(acc, transaction.amount)
        end)
    end
  end

  defp get_month_transactions(forecast, year, month) do
    Map.get(forecast, %{year: year, month: month}, [])
  end
end