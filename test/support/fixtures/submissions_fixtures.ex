defmodule Marginalia.SubmissionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Marginalia.Submissions` context.
  """

  @doc """
  Generate a submission.
  """
  def submission_fixture(attrs \\ %{}) do
    {:ok, submission} =
      attrs
      |> Enum.into(%{
        feedback: "some feedback",
        raw_text: "some raw_text",
        status: "some status"
      })
      |> Marginalia.Submissions.create_submission()

    submission
  end
end
