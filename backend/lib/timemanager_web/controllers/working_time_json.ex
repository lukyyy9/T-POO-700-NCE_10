defmodule TimemanagerWeb.WorkingTimeJSON do
  alias Timemanager.WorkingTimeContext.WorkingTime

  @doc """
  Renders a list of workingtime.
  """
  def index(%{workingtime: workingtime}) do
    %{data: for(working_time <- workingtime, do: data(working_time))}
  end





  @doc """
  Renders a single working_time.
  """
  def show(%{working_time: nil}) do
    %{errors: %{detail: "Working time not found"}}
  end

  def show(%{working_time: working_time}) do
    %{data: data(working_time)}
  end

  defp data(%WorkingTime{} = working_time) do
    %{
      id: working_time.id,
      user_id: working_time.user_id,
      start: working_time.start,
      end: working_time.end
    }
  end
end
