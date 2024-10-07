defmodule PfmPhoenix.Transactions.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :date, :date
    field :description, :string
    field :category, :string
    field :amount, :decimal
    belongs_to :user, PfmPhoenix.Accounts.User
    belongs_to :budget, PfmPhoenix.Finance.Budget

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :description, :date, :category, :user_id, :budget_id])
    |> validate_required([:amount, :description, :date, :category, :user_id, :budget_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:budget_id)
  end
end
