defmodule Timemanager.WorkingTimeContextTest do
  use Timemanager.DataCase

  alias Timemanager.WorkingTimeContext

  describe "workingtime" do
    alias Timemanager.WorkingTimeContext.WorkingTime

    import Timemanager.WorkingTimeContextFixtures

    @invalid_attrs %{start: nil, end: nil}

    test "list_workingtime/0 returns all workingtime" do
      working_time = working_time_fixture()
      assert WorkingTimeContext.list_workingtime() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert WorkingTimeContext.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2024-10-07 10:10:00], end: ~N[2024-10-07 10:10:00]}

      assert {:ok, %WorkingTime{} = working_time} = WorkingTimeContext.create_working_time(valid_attrs)
      assert working_time.start == ~N[2024-10-07 10:10:00]
      assert working_time.end == ~N[2024-10-07 10:10:00]
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = WorkingTimeContext.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~N[2024-10-08 10:10:00], end: ~N[2024-10-08 10:10:00]}

      assert {:ok, %WorkingTime{} = working_time} = WorkingTimeContext.update_working_time(working_time, update_attrs)
      assert working_time.start == ~N[2024-10-08 10:10:00]
      assert working_time.end == ~N[2024-10-08 10:10:00]
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = WorkingTimeContext.update_working_time(working_time, @invalid_attrs)
      assert working_time == WorkingTimeContext.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = WorkingTimeContext.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> WorkingTimeContext.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = WorkingTimeContext.change_working_time(working_time)
    end
  end
end
