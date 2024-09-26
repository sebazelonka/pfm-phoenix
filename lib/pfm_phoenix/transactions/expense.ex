defmodule PfmPhoenix.Transactions.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  schema "expenses" do
    field :date, :date
    field :description, :string
    field :category, :string
    field :amount, :decimal
    belongs_to :user, PfmPhoenix.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :description, :date, :category, :user_id])
    |> validate_required([:amount, :description, :date, :category, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
