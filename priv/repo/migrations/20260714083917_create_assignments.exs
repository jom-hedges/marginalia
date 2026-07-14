defmodule Marginalia.Repo.Migrations.CreateAssignments do
  use Ecto.Migration

  def change do
    create table(:assignments) do
      add :title, :string
      add :prompt, :text
      add :due_date, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
