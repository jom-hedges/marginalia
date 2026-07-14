defmodule Marginalia.AssignmentsTest do
  use Marginalia.DataCase

  alias Marginalia.Assignments

  describe "assignments" do
    alias Marginalia.Assignments.Assignment

    import Marginalia.AssignmentsFixtures

    @invalid_attrs %{title: nil, prompt: nil, due_date: nil}

    test "list_assignments/0 returns all assignments" do
      assignment = assignment_fixture()
      assert Assignments.list_assignments() == [assignment]
    end

    test "get_assignment!/1 returns the assignment with given id" do
      assignment = assignment_fixture()
      assert Assignments.get_assignment!(assignment.id) == assignment
    end

    test "create_assignment/1 with valid data creates a assignment" do
      valid_attrs = %{title: "some title", prompt: "some prompt", due_date: ~U[2026-07-13 08:39:00Z]}

      assert {:ok, %Assignment{} = assignment} = Assignments.create_assignment(valid_attrs)
      assert assignment.title == "some title"
      assert assignment.prompt == "some prompt"
      assert assignment.due_date == ~U[2026-07-13 08:39:00Z]
    end

    test "create_assignment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Assignments.create_assignment(@invalid_attrs)
    end

    test "update_assignment/2 with valid data updates the assignment" do
      assignment = assignment_fixture()
      update_attrs = %{title: "some updated title", prompt: "some updated prompt", due_date: ~U[2026-07-14 08:39:00Z]}

      assert {:ok, %Assignment{} = assignment} = Assignments.update_assignment(assignment, update_attrs)
      assert assignment.title == "some updated title"
      assert assignment.prompt == "some updated prompt"
      assert assignment.due_date == ~U[2026-07-14 08:39:00Z]
    end

    test "update_assignment/2 with invalid data returns error changeset" do
      assignment = assignment_fixture()
      assert {:error, %Ecto.Changeset{}} = Assignments.update_assignment(assignment, @invalid_attrs)
      assert assignment == Assignments.get_assignment!(assignment.id)
    end

    test "delete_assignment/1 deletes the assignment" do
      assignment = assignment_fixture()
      assert {:ok, %Assignment{}} = Assignments.delete_assignment(assignment)
      assert_raise Ecto.NoResultsError, fn -> Assignments.get_assignment!(assignment.id) end
    end

    test "change_assignment/1 returns a assignment changeset" do
      assignment = assignment_fixture()
      assert %Ecto.Changeset{} = Assignments.change_assignment(assignment)
    end
  end
end
