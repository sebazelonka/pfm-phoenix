defmodule PfmPhoenixWeb.PageController do
  use PfmPhoenixWeb, :controller
  require Logger
  alias PfmPhoenix.Expenses

  def home(conn, _params) do
    expenses = Expenses.list_expenses()

    # generate an array the sum of the amounts per category
    elementos =
      expenses
      # Group by category
      |> Enum.group_by(& &1.category)
      |> Enum.map(fn {category, items} ->
        Logger.debug("Items: #{inspect(items)}")

        total_amount =
          items
          |> Enum.reduce(0, fn item, acc ->
            # Convert the Decimal to float and sum the amounts
            amount = Decimal.to_float(item.amount)
            Logger.debug("Item amount: #{inspect(amount)}")
            acc + amount
          end)

        # Convert the total_amount to a string (binaries) with two decimal places
        %{category: category, total_amount: total_amount}
      end)

    Logger.debug("Elementos: #{inspect(elementos)}")

    totals = Enum.map(elementos, fn elem -> elem.total_amount end)
    Logger.debug("Totals: #{inspect(totals)}")

    # generate an array of all categories in list_expenses.category
    categories =
      expenses
      # Get the category from each expense
      |> Enum.map(fn expenses -> expenses.category end)
      # Convert each element to lowercase
      |> Enum.map(fn element -> String.downcase(element) end)
      # Create a MapSet to remove duplicates
      |> MapSet.new()
      |> MapSet.to_list()

    Logger.debug("Categories: #{inspect(categories)}")

    # Get the 5 most recent expenses
    table =
      expenses
      # get amount from each expense
      # |> Enum.map(fn expenses -> expenses.amount end)
      |> Enum.reverse()
      |> Enum.take(5)

    render(conn, :home,
      expenses: table,
      data: totals,
      categories: categories,
      elementos: elementos
    )
  end
end
