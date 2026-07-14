defmodule Marginalia.Submissions.Submission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "submissions" do
    field :status, Ecto.Enum, values: [:pending, :processing, :completed, :failed], default: :pending
    field :raw_text, :string
    field :feedback, :string
    
    belongs_to :assignment, Marginalia. Assignments.Assignment
    belongs_to :student, Marginalia.Accounts.User, foreign_key: :user_id
    
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:raw_text, :status, :feedback, :assignment_id, :user_id])
    |> validate_required([:raw_text, :status, :feedback, :assignment_id, :user_id])
    |> foreign_key_constraint(:assignment_id)
    |> foreign_key_constraint(:user_id)
  end
end
