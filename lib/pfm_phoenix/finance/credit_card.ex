defmodule PfmPhoenix.Finance.CreditCard do
  use Ecto.Schema
  import Ecto.Changeset

  schema "credit_cards" do
    field :name, :string
    field :limit, :decimal
    field :interest_rate, :decimal
    field :closing_date, :integer
    field :payment_due_date, :integer
    belongs_to :user, PfmPhoenix.Accounts.User
    has_many :transactions, PfmPhoenix.Transactions.Transaction

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(credit_card, attrs) do
    credit_card
    |> cast(attrs, [:name, :limit, :interest_rate, :closing_date, :payment_due_date, :user_id])
    |> validate_required([:name, :user_id])
    |> validate_number(:limit, greater_than: 0)
    |> validate_number(:interest_rate, greater_than_or_equal_to: 0, less_than_or_equal_to: 100)
    |> validate_number(:closing_date, greater_than: 0, less_than_or_equal_to: 31)
    |> validate_number(:payment_due_date, greater_than: 0, less_than_or_equal_to: 31)
    |> foreign_key_constraint(:user_id)
  end
end