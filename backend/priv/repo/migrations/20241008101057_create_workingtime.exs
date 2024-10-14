defmodule Timemanager.Repo.Migrations.CreateWorkingtime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:workingtime, [:user_id])
  end
end
