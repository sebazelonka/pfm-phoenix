defmodule PfmPhoenixWeb.ExpenseLive.FormComponent do
  use PfmPhoenixWeb, :live_component

  alias PfmPhoenix.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage expense records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="expense-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:category]} type="text" label="Category" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Expense</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{expense: expense, current_user: current_user} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_user, current_user)
     |> assign_form(Transactions.change_expense(expense))}
  end

  @impl true
  def handle_event("validate", %{"expense" => expense_params}, socket) do
    changeset = Transactions.change_expense(socket.assigns.expense, expense_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"expense" => expense_params}, socket) do
    save_expense(socket, socket.assigns.action, expense_params)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp save_expense(socket, :edit, expense_params) do
    case Transactions.update_expense(socket.assigns.expense, expense_params) do
      {:ok, expense} ->
        notify_parent({:saved, expense})

        {:noreply,
         socket
         |> put_flash(:info, "Expense updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_expense(socket, :new, expense_params) do
    case create_expense(expense_params, socket.assigns.current_user) do
      {:ok, expense} ->
        notify_parent({:saved, expense})

        {:noreply,
         socket
         |> put_flash(:info, "Expense created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp create_expense(params, user) do
    Transactions.create_expense(params, user)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
