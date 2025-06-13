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
    field :installments_count, :integer
    field :installment_number, :integer
    belongs_to :user, PfmPhoenix.Accounts.User
    belongs_to :budget, PfmPhoenix.Finance.Budget
    belongs_to :credit_card, PfmPhoenix.Finance.CreditCard
    belongs_to :parent_transaction, __MODULE__
    has_many :child_transactions, __MODULE__, foreign_key: :parent_transaction_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:amount, :description, :date, :category, :type, :user_id, :budget_id, :credit_card_id, :installments_count, :installment_number, :parent_transaction_id])
    |> validate_required([:amount, :description, :date, :category, :type, :user_id, :budget_id])
    |> validate_number(:installments_count, greater_than: 0)
    |> validate_number(:installment_number, greater_than: 0)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:budget_id)
    |> foreign_key_constraint(:credit_card_id)
    |> foreign_key_constraint(:parent_transaction_id)
  end
end
