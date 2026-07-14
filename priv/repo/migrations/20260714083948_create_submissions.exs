defmodule Marginalia.Repo.Migrations.CreateSubmissions do
  use Ecto.Migration

  def change do
    create table(:submissions) do
      add :raw_text, :text
      add :status, :string
      add :feedback, :text
      add :assignment_id, references(:assignments, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:submissions, [:assignment_id])
    create index(:submissions, [:user_id])
  end
end
