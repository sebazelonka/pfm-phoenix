defmodule PfmPhoenix.Finance.Budget do
  use Ecto.Schema
  import Ecto.Changeset

  schema "budgets" do
    field :name, :string
    field :description, :string
    field :user_id, :id
    has_many :expenses, PfmPhoenix.Transactions.Expense

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(budget, attrs) do
    budget
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :description, :user_id])
  end
end
