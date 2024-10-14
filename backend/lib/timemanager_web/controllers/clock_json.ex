defmodule TimemanagerWeb.ClockJSON do
  alias Timemanager.ClockContext.Clock

  @doc """
  Renders a list of clocks.
  """
  def index(%{clocks: clocks}) do
    %{data: for(clock <- clocks, do: data(clock))}
  end

  @doc """
  Renders a single clock.
  """
  def show(%{clock: nil}) do
    %{errors: %{detail: "Clock not found"}}
  end

  def show(%{clock: clock}) do
    %{data: data(clock)}
  end

  defp data(%Clock{} = clock) do
    %{
      id: clock.id,
      status: clock.status,
      time: clock.time
    }
  end
end