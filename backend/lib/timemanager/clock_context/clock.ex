defmodule Timemanager.ClockContext.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    field :user_id, :integer
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:status, :time, :user_id])
    |> validate_required([:status, :time, :user_id])
    |> foreign_key_constraint(:user_id, name: "clocks_user_id_fkey")
  end
end
