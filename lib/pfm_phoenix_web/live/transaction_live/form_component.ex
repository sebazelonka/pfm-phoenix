defmodule PfmPhoenixWeb.TransactionLive.FormComponent do
  use PfmPhoenixWeb, :live_component

  alias PfmPhoenix.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage transaction records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="transaction-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:type]}
          type="select"
          label="Select transaction type"
          options={["income", "expense"]}
          prompt="Select transaction type"
        />
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:date]} type="date" label="Date" />
        <%!-- categories should be dynamic --%>
        <.input
          field={@form[:category]}
          type="select"
          label="Select category"
          options={[
            "auto",
            "supermercado",
            "hobbies",
            "salidas",
            "otros",
            "tarjetas",
            "familia",
            "sueldo",
            "extras"
          ]}
          prompt="Select category"
        />

        <.input
          field={@form[:budget_id]}
          type="select"
          label="Select budget"
          options={Enum.map(@budgets, &{&1.name, &1.id})}
        />

        <.input
          field={@form[:credit_card_id]}
          type="select"
          label="Credit Card (optional)"
          options={Enum.map(@credit_cards, &{&1.name, &1.id})}
          prompt="Select credit card (if applicable)"
        />

        <.input
          field={@form[:installments_count]}
          type="number"
          label="Number of Installments"
          placeholder="Leave empty for single payment"
          min="1"
          max="24"
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Transaction</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{transaction: transaction} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Transactions.change_transaction(transaction))
     end)}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    changeset = Transactions.change_transaction(socket.assigns.transaction, transaction_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    save_transaction(socket, socket.assigns.action, transaction_params)
  end

  defp save_transaction(socket, :edit, transaction_params) do
    case Transactions.update_transaction(socket.assigns.transaction, transaction_params) do
      {:ok, transaction} ->
        notify_parent({:saved, transaction})

        {:noreply,
         socket
         |> put_flash(:info, "Transaction updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_transaction(socket, :new, transaction_params) do
    # Use installment creation if installments_count is provided
    create_function = if Map.get(transaction_params, "installments_count") && 
                        String.to_integer(Map.get(transaction_params, "installments_count", "1")) > 1 do
      &Transactions.create_transaction_with_installments/2
    else
      &Transactions.create_transaction/2
    end
    
    case create_function.(transaction_params, socket.assigns.current_user) do
      {:ok, transaction} ->
        notify_parent({:saved, transaction})

        {:noreply,
         socket
         |> put_flash(:info, "Transaction created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
