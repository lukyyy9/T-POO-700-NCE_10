defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.ClockContext
  alias Timemanager.ClockContext.Clock

  action_fallback TimemanagerWeb.FallbackController

  def get_by_user_id(conn, %{"user_id" => user_id}) do
    clocks = ClockContext.get_by_user_id(user_id)
    render(conn, "index.json", clocks: clocks)
  end

  def index(conn, _params) do
    clocks = ClockContext.list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    current_time = NaiveDateTime.utc_now()

    last_clocking = ClockContext.get_last_clocking(user_id)

    new_status = case last_clocking do
      nil -> true
      clock -> not clock.status
    end

    clock_params = %{
      "user_id" => user_id,
      "status" => new_status,
      "time" => current_time
    }

    with {:ok, %Clock{} = clock} <- ClockContext.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock.id}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = ClockContext.get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = ClockContext.get_clock!(id)

    with {:ok, %Clock{} = clock} <- ClockContext.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = ClockContext.get_clock!(id)

    with {:ok, %Clock{}} <- ClockContext.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
