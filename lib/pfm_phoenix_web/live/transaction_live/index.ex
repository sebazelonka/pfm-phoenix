defmodule PfmPhoenixWeb.TransactionLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Finance
  alias PfmPhoenix.Transactions
  alias PfmPhoenix.Transactions.Transaction

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}

  @impl true
  def mount(_params, _session, socket) do
    # Initialize default filters
    filters = %{
      start_date: nil,
      end_date: nil,
      type: nil,
      category: nil
    }

    transactions = Transactions.list_transactions(socket.assigns.current_user)
    transactions = Enum.sort_by(transactions, & &1.date, :desc)

    {:ok,
     socket
     |> assign(:current_user, socket.assigns.current_user)
     |> assign(:budget, Finance.list_budgets(socket.assigns.current_user))
     |> assign(:filters, filters)
     |> assign(:transaction_types, [:income, :expense])
     |> assign(:categories, [:auto, :supermercado, :hobbies, :salidas, :otros, :tarjetas, :familia, :sueldo, :extras])
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

  @impl true
  def handle_event("apply_filters", %{"filters" => filter_params}, socket) do
    # Parse dates if present
    filters = %{
      start_date: parse_date(filter_params["start_date"]),
      end_date: parse_date(filter_params["end_date"]),
      type: filter_params["type"],
      category: filter_params["category"]
    }
    
    # Get filtered transactions
    transactions = Transactions.list_transactions(socket.assigns.current_user, filters)
    
    {:noreply, 
     socket
     |> assign(:filters, filters)
     |> stream(:transactions, transactions, reset: true)}
  end

  @impl true
  def handle_event("reset_filters", _params, socket) do
    # Reset to default filters
    filters = %{
      start_date: nil,
      end_date: nil,
      type: nil,
      category: nil
    }
    
    # Get all transactions
    transactions = Transactions.list_transactions(socket.assigns.current_user)
    transactions = Enum.sort_by(transactions, & &1.date, :desc)
    
    {:noreply, 
     socket
     |> assign(:filters, filters)
     |> stream(:transactions, transactions, reset: true)}
  end

  defp parse_date(""), do: nil
  defp parse_date(nil), do: nil
  defp parse_date(date_string) do
    case Date.from_iso8601(date_string) do
      {:ok, date} -> date
      _ -> nil
    end
  end


end
