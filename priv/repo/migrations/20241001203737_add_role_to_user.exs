defmodule PfmPhoenix.Repo.Migrations.AddRoleToUser do
  use Ecto.Migration

  alias PfmPhoenix.Accounts.User.RolesEnum

  def change do
    RolesEnum.create_type()

    alter table(:users) do
      add :role, RolesEnum.type(), null: false
    end
  end
end
