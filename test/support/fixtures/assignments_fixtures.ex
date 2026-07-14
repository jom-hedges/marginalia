defmodule Marginalia.AssignmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Marginalia.Assignments` context.
  """

  @doc """
  Generate a assignment.
  """
  def assignment_fixture(attrs \\ %{}) do
    {:ok, assignment} =
      attrs
      |> Enum.into(%{
        due_date: ~U[2026-07-13 08:39:00Z],
        prompt: "some prompt",
        title: "some title"
      })
      |> Marginalia.Assignments.create_assignment()

    assignment
  end
end
