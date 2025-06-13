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

# Create admin user
{:ok, admin} = Accounts.register_admin_user(%{
  email: "admin@example.com",
  password: "new_password_1234"
})

# Create test user
{:ok, {user, default_budget}} = Accounts.register_user(%{
  email: "user@example.com",
  password: "new_password_1234"
})

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

IO.puts("\nSeed data created successfully!")
IO.puts("Admin user: admin@example.com / new_password_1234")
IO.puts("Test user: user@example.com / new_password_1234")
