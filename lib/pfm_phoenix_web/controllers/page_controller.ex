defmodule PfmPhoenixWeb.PageController do
  use PfmPhoenixWeb, :controller
  alias PfmPhoenix.Expenses

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    socket =
      Expenses.list_expenses()
      |> Enum.reverse()
      |> Enum.take(5)

    # Get the 5 most recent expenses
    expenses =
      Expenses.list_expenses()
      # get amount from each expense
      # |> Enum.map(fn expenses -> expenses.amount end)
      |> Enum.reverse()
      |> Enum.take(5)

    render(conn, :home, expenses: expenses, sockets: socket)
  end

  # def index(conn, _params) do

  #   render(conn, :index, )
  # end
end
