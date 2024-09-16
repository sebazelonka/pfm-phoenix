defmodule PfmPhoenixWeb.PageController do
  use PfmPhoenixWeb, :controller
  alias PfmPhoenix.Expenses

  def home(conn, _params) do
    expenses = Expenses.list_expenses()

    # Get the 5 most recent expenses
    table =
      expenses
      # get amount from each expense
      # |> Enum.map(fn expenses -> expenses.amount end)
      |> Enum.reverse()
      |> Enum.take(5)

    # generate an array the sum of the amounts per category
    data =
      expenses
      # Group by category
      |> Enum.group_by(fn expense -> expense.category end)
      |> Enum.map(fn {category, items} ->
        total_amount =
          items
          |> Enum.reduce(0, fn item, acc ->
            # Convert the Decimal to float and sum the amounts
            amount = Decimal.to_float(item.amount)
            acc + amount
          end)

        # Convert the total_amount to a string (binaries) with two decimal places
        %{label: category, value: total_amount}
      end)
      |> Jason.encode!()

    render(conn, :home,
      expenses: table,
      data: data
    )
  end
end
