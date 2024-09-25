defmodule PfmPhoenixWeb.IncomeLive.FormComponent do
  use PfmPhoenixWeb, :live_component

  alias PfmPhoenix.Transactions

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage income records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="income-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:amount]} type="number" label="Amount" step="any" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:date]} type="date" label="Date" />
        <.input field={@form[:category]} type="text" label="Category" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Income</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  # def update(%{income: income, current_user: current_user} = assigns, socket) do
  def update(%{income: income, current_user: current_user} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign(:current_user, current_user)
     |> assign_form(Transactions.change_income(income))}

    #  |> assign_new(:form, fn ->
    #    to_form(Transactions.change_income(income))
    #  end)}
  end

  @impl true
  def handle_event("validate", %{"income" => income_params}, socket) do
    changeset = Transactions.change_income(socket.assigns.income, income_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"income" => income_params}, socket) do
    save_income(socket, socket.assigns.action, income_params)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp save_income(socket, :edit, income_params) do
    case Transactions.update_income(socket.assigns.income, income_params) do
      {:ok, income} ->
        notify_parent({:saved, income})

        {:noreply,
         socket
         |> put_flash(:info, "Income updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_income(socket, :new, income_params) do
    case create_income(income_params, socket.assigns.current_user) do
      {:ok, income} ->
        notify_parent({:saved, income})

        {:noreply,
         socket
         |> put_flash(:info, "Income created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp create_income(params, user) do
    Transactions.create_income(params, user)
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
