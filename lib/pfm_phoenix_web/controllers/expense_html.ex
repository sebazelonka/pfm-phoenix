defmodule PfmPhoenixWeb.ExpenseHTML do
  use PfmPhoenixWeb, :html

  embed_templates "expense_html/*"

  @doc """
  Renders a expense form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def expense_form(assigns)
end
