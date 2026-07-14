defmodule Marginalia.Repo.Migrations.AddNameAndRoleToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :string
      add :role, :string, null: false, default: "student"
    end
  end
end
