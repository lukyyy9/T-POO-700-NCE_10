defmodule Timemanager.WorkingTimeContextFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.WorkingTimeContext` context.
  """

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2024-10-07 10:10:00],
        start: ~N[2024-10-07 10:10:00]
      })
      |> Timemanager.WorkingTimeContext.create_working_time()

    working_time
  end
end
