defmodule TimemanagerWeb.ClockController do
  use TimemanagerWeb, :controller

  alias Timemanager.ClockContext
  alias Timemanager.ClockContext.Clock

  action_fallback(TimemanagerWeb.FallbackController)

  defp clock_context do
    Application.get_env(:timemanager, :clock_context, Timemanager.ClockContext)
  end

  def get_by_user_id(conn, %{"user_id" => user_id}) do
    user_id = String.to_integer(user_id)
    clocks = clock_context().get_by_user_id(user_id)
    render(conn, "index.json", clocks: clocks)
  end

  def index(conn, _params) do
    clocks = clock_context().list_clocks()
    render(conn, :index, clocks: clocks)
  end

  def create(conn, %{"user_id" => user_id}) when not is_nil(user_id) do
    user_id = String.to_integer(user_id)
    current_time = NaiveDateTime.utc_now()|> NaiveDateTime.add(2 * 3600)

    new_status =
      case last_clocking do
        nil -> true
        clock -> not clock.status
      end

    clock_params = %{
      "status" => new_status,
      "time" => current_time,
      "user_id" => user_id
    }

    case clock_context().create_clock(clock_params) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", ~p"/api/clocks/#{user_id}")
        |> render(:show, clock: clock)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimemanagerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = clock_context().get_clock!(id)
    render(conn, :show, clock: clock)
  end

  def update(conn, %{"id" => id_str, "clock" => clock_params}) do
    id = String.to_integer(id_str)
    clock = clock_context().get_clock!(id)

    case clock_context().update_clock(clock, clock_params) do
      {:ok, %Clock{} = updated_clock} ->
        render(conn, :show, clock: updated_clock)
      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimemanagerWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end


  def delete(conn, %{"id" => id}) do
    id = String.to_integer(id)
    case clock_context().get_clock(id) do
      nil ->
        send_resp(conn, :not_found, "")
      clock ->
        case clock_context().delete_clock(clock) do
          {:ok, _deleted_clock} ->
            send_resp(conn, :no_content, "")
          {:error, _changeset} ->
            send_resp(conn, :unprocessable_entity, "")
        end
    end
  end

  #defp impl, do: Application.get_env(:timemanager, :clock, Timemanager.ClockContext)

end
