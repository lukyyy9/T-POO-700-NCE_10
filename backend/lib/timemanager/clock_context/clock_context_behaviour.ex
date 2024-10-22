defmodule Timemanager.ClockContextBehaviour do
  @callback list_clocks() :: [%Timemanager.ClockContext.Clock{}]
  @callback get_by_user_id(integer()) :: [%Timemanager.ClockContext.Clock{}]
  @callback get_clock(integer()) :: %Timemanager.ClockContext.Clock{} | nil
  @callback get_clock!(integer()) :: %Timemanager.ClockContext.Clock{} | nil
  @callback create_clock(map()) :: {:ok, %Timemanager.ClockContext.Clock{}} | {:error, %Ecto.Changeset{}}
  @callback update_clock(%Timemanager.ClockContext.Clock{}, map()) :: {:ok, %Timemanager.ClockContext.Clock{}} | {:error, %Ecto.Changeset{}}
  @callback delete_clock(%Timemanager.ClockContext.Clock{}) :: {:ok, %Timemanager.ClockContext.Clock{}} | {:error, %Ecto.Changeset{}}
  @callback get_last_clocking(integer()) :: %Timemanager.ClockContext.Clock{} | nil
end
