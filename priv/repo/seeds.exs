# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     PfmPhoenix.Repo.insert!(%PfmPhoenix.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias PfmPhoenix.Repo
alias PfmPhoenix.Accounts
alias PfmPhoenix.Finance
alias PfmPhoenix.Transactions
alias PfmPhoenix.Transactions.Transaction

# Get or create admin user
admin = case Accounts.register_admin_user(%{
  email: "admin@example.com",
  password: "new_password_1234"
}) do
  {:ok, admin} -> admin
  {:error, _changeset} -> Repo.get_by!(PfmPhoenix.Accounts.User, email: "admin@example.com")
end

# Get or create test user
{user, default_budget} = case Accounts.register_user(%{
  email: "user@example.com",
  password: "new_password_1234"
}) do
  {:ok, {user, default_budget}} -> {user, default_budget}
  {:error, _changeset} -> 
    user = Repo.get_by!(PfmPhoenix.Accounts.User, email: "user@example.com")
    default_budget = Finance.list_budgets(user) |> Enum.find(fn b -> b.name == "Default" end)
    {user, default_budget}
end

# Create credit cards
{:ok, visa_card} = Finance.create_credit_card(%{
  "name" => "Visa Card",
  "limit" => 5000,
  "interest_rate" => 18.5,
  "closing_date" => 15,
  "payment_due_date" => 25
}, user)

{:ok, mastercard} = Finance.create_credit_card(%{
  "name" => "MasterCard Premium",
  "limit" => 10000,
  "interest_rate" => 15.2,
  "closing_date" => 10,
  "payment_due_date" => 20
}, user)

# Create additional budgets
{:ok, vacation_budget} = Finance.create_budget(%{
  "name" => "Vacation",
  "description" => "Budget for vacations"
}, user)

{:ok, education_budget} = Finance.create_budget(%{
  "name" => "Education",
  "description" => "Budget for courses and books"
}, user)

# Get all budgets for the user
budgets = [default_budget, vacation_budget, education_budget]

# Available categories for transactions
expense_categories = [:auto, :supermercado, :hobbies, :salidas, :otros, :tarjetas, :familia]
income_categories = [:sueldo, :extras]

# Generate random transactions
for i <- 1..50 do
  # Determine if this will be an income or expense (30% income, 70% expense)
  type = if :rand.uniform(10) <= 3, do: :income, else: :expense

  # Select appropriate categories based on transaction type
  category = case type do
    :income -> Enum.random(income_categories)
    :expense -> Enum.random(expense_categories)
  end

  # Generate a random amount (incomes are typically larger)
  amount = case type do
    :income -> :rand.uniform(5000) + 1000
    :expense -> :rand.uniform(1000) + 10
  end

  # Generate a random date within the last year
  days_ago = :rand.uniform(365)
  date = Date.add(Date.utc_today(), -days_ago)

  # Select a random budget
  budget = Enum.random(budgets)

  # Create description based on category and type
  description = case {type, category} do
    {:income, :sueldo} -> "Salario mensual"
    {:income, :extras} -> "Ingreso extra #{i}"
    {:expense, :auto} -> "Gasto de auto #{i}"
    {:expense, :supermercado} -> "Compra en supermercado #{i}"
    {:expense, :hobbies} -> "Gasto en hobby #{i}"
    {:expense, :salidas} -> "Salida con amigos #{i}"
    {:expense, :otros} -> "Otro gasto #{i}"
    {:expense, :tarjetas} -> "Pago de tarjeta #{i}"
    {:expense, :familia} -> "Gasto familiar #{i}"
    _ -> "Transacción #{i}"
  end

  # Create the transaction
  {:ok, _transaction} = Transactions.create_transaction(
    %{
      "amount" => amount,
      "description" => description,
      "date" => date,
      "category" => category,
      "type" => type,
      "budget_id" => budget.id
    },
    user
  )

  # Print progress
  IO.puts("Created transaction #{i}/50: #{type} - #{category} - $#{amount}")
end

# Create some installment transactions for credit cards
IO.puts("Creating installment transactions...")

# Check if installment transactions already exist
existing_laptop = Repo.get_by(PfmPhoenix.Transactions.Transaction, 
  description: "Laptop Purchase", 
  user_id: user.id
)

existing_furniture = Repo.get_by(PfmPhoenix.Transactions.Transaction, 
  description: "Furniture Set", 
  user_id: user.id
)

# Create a large purchase with installments only if it doesn't exist
if is_nil(existing_laptop) do
  {:ok, _laptop_transaction} = Transactions.create_transaction_with_installments(
    %{
      "amount" => "1200",
      "description" => "Laptop Purchase",
      "date" => Date.to_iso8601(Date.utc_today()),
      "category" => "otros",
      "type" => "expense",
      "budget_id" => default_budget.id,
      "credit_card_id" => visa_card.id,
      "installments_count" => "12"
    },
    user
  )
  IO.puts("Created Laptop Purchase installment transactions")
else
  IO.puts("Laptop Purchase installment transactions already exist")
end

# Create furniture purchase with installments only if it doesn't exist
if is_nil(existing_furniture) do
  {:ok, _furniture_transaction} = Transactions.create_transaction_with_installments(
    %{
      "amount" => "800",
      "description" => "Furniture Set",
      "date" => Date.to_iso8601(Date.add(Date.utc_today(), 5)),
      "category" => "familia",
      "type" => "expense",
      "budget_id" => vacation_budget.id,
      "credit_card_id" => mastercard.id,
      "installments_count" => "6"
    },
    user
  )
  IO.puts("Created Furniture Set installment transactions")
else
  IO.puts("Furniture Set installment transactions already exist")
end

IO.puts("\nSeed data created successfully!")
IO.puts("Admin user: admin@example.com / new_password_1234")
IO.puts("Test user: user@example.com / new_password_1234")
IO.puts("Credit cards and installment transactions have been created!")
