defmodule Timemanager.Repo.Migrations.AddRoleToUsersManagerAdmin do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :integer, default: 1
    end
  end
end
