defmodule PfmPhoenix.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field :type, :string
    field :date, :date
    field :description, :string
    field :category, :string
    field :amount, :decimal
    belongs_to :user, PfmPhoenix.Accounts.User
    belongs_to :budget, PfmPhoenix.Finance.Budget

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :description, :date, :category, :type, :user_id, :budget_id])
    |> validate_required([:amount, :description, :date, :category, :type, :user_id, :budget_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:budget_id)
  end
end
