defmodule Marginalia.Assignments.Assignment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "assignments" do
    field :title, :string
    field :prompt, :string
    field :due_date, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(assignment, attrs) do
    assignment
    |> cast(attrs, [:title, :prompt, :due_date])
    |> validate_required([:title, :prompt, :due_date])
  end
end
