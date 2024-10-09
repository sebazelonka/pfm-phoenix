defmodule PfmPhoenixWeb.Helpers do
  def format_currency(amount) do
    Number.Currency.number_to_currency(amount, precision: 0, delimiter: ".", unit: "$")
  end
end
