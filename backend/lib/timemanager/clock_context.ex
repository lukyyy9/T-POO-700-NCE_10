defmodule Timemanager.ClockContext do
  @moduledoc """
  The ClockContext context.
  """

  import Ecto.Query, warn: false
  @repo Application.get_env(:timemanager, :repo)

  alias Timemanager.ClockContext.Clock
  @behaviour Timemanager.ClockContextBehaviour

  def get_by_user_id(user_id) do
    query = from(c in Clock, where: c.user_id == ^user_id)
    @repo.all(query)
  end

  @doc """
  Returns the list of clocks.
  """
  def list_clocks do
    @repo.all(Clock)
  end

  # Récupérer une horloge par ID (sans lever d'exception)
  def get_clock(id) do
    @repo.get(Clock, id)
  end

  @doc """
  Gets a single clock.
  """
  def get_clock!(id), do: @repo.get!(Clock, id)

  @doc """
  Creates a clock.
  """
  def create_clock(attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(attrs)
    |> @repo.insert()
  end

  @doc """
  Updates a clock.
  """
  def update_clock(%Clock{} = clock, attrs) do
    clock
    |> Clock.changeset(attrs)
    |> @repo.update()
  end

  @doc """
  Deletes a clock.
  """
  def delete_clock(%Clock{} = clock) do
    @repo.delete(clock)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clock changes.
  """
  def change_clock(%Clock{} = clock, attrs \\ %{}) do
    Clock.changeset(clock, attrs)
  end

  def get_last_clocking(user_id) do
    Clock
    |> where([c], c.user_id == ^user_id)
    |> order_by(desc: :inserted_at)
    |> limit(1)
    |> @repo.one()
  end
end
