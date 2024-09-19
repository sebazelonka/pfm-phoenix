defmodule PfmPhoenixWeb.ExpenseController do
  use PfmPhoenixWeb, :controller

  alias PfmPhoenix.Expenses
  alias PfmPhoenix.Expenses.Expense

  plug :require_authenticated_user

  def index(conn, _params) do
    current_user = Pow.Plug.current_user(conn)
    expenses = Expenses.list_user_expenses(current_user)

    list = Enum.reverse(expenses)

    render(conn, :index, expenses: list)
  end

  def new(conn, _params) do
    changeset = Expenses.change_expense(%Expense{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"expense" => expense_params}) do
    current_user = Pow.Plug.current_user(conn)

    IO.inspect(current_user, label: "Current User")
    IO.inspect(expense_params, label: "Expense Params")

    case Expenses.create_expense(current_user, expense_params) do
      {:ok, expense} ->
        IO.puts("Expense created successfully")

        conn
        |> put_flash(:info, "Expense created successfully. #{expense.category}")
        |> redirect(to: ~p"/expenses")

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset.errors, label: "Changeset Errors")
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user = Pow.Plug.current_user(conn)

    case Expenses.get_user_expense(current_user, id) do
      nil -> handle_unauthorized_access(conn)
      expense -> render(conn, :show, expense: expense)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user = Pow.Plug.current_user(conn)
    expense = Expenses.get_user_expense(current_user, id)

    changeset = Expenses.change_expense(expense)
    render(conn, :edit, expense: expense, changeset: changeset)
  end

  def update(conn, %{"id" => id, "expense" => expense_params}) do
    current_user = Pow.Plug.current_user(conn)
    expense = Expenses.get_user_expense(current_user, id)

    case Expenses.update_expense(expense, expense_params) do
      {:ok, expense} ->
        conn
        |> put_flash(:info, "Expense updated successfully.")
        |> redirect(to: ~p"/expenses/#{expense}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, expense: expense, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Pow.Plug.current_user(conn)
    expense = Expenses.get_user_expense(current_user, id)
    {:ok, _expense} = Expenses.delete_expense(expense)

    conn
    |> put_flash(:info, "Expense deleted successfully.")
    |> redirect(to: ~p"/expenses")
  end

  defp require_authenticated_user(conn, _opts) do
    if Pow.Plug.current_user(conn) do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access this page.")
      # Adjust this path to your login route
      |> redirect(to: ~p"/session/new")
      |> halt()
    end
  end

  defp handle_unauthorized_access(conn) do
    conn
    |> put_flash(:error, "You don't have permission to access this expense.")
    |> redirect(to: ~p"/expenses")
    |> halt()
  end
end
