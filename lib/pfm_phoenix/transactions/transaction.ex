defmodule PfmPhoenix.Transactions.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  import EctoEnum

  defenum(TransactionType, :type, [
    :income,
    :expense
  ])

  defenum(Categories, :category, [
    :auto,
    :supermercado,
    :hobbies,
    :salidas,
    :otros,
    :tarjetas,
    :familia,
    :sueldo,
    :extras
  ])

  schema "transactions" do
    field :type, TransactionType
    field :date, :date
    field :description, :string
    field :category, Categories
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
