defmodule PfmPhoenixWeb.Helpers do
  def format_currency(amount) do
    Number.Currency.number_to_currency(amount, delimiter: ".", unit: "$")
  end
end
