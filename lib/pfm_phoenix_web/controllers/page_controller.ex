defmodule PfmPhoenixWeb.PageController do
  use PfmPhoenixWeb, :controller
  alias PfmPhoenix.Expenses

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.

    # Get the 5 most recent expenses
    expenses =
      Expenses.list_expenses()
      |> Enum.reverse()
      |> Enum.take(5)

    render(conn, :home, expenses: expenses)
  end

  # def index(conn, _params) do

  #   render(conn, :index, )
  # end
end
