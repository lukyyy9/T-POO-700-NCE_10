defmodule Timemanager.Repo.Migrations.AddManagerIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :manager_id, references(:users, on_delete: :nothing)
    end

    create index(:users, [:manager_id]) # Ajoute un index pour améliorer les performances des requêtes
  end
end
