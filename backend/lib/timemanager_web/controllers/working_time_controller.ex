defmodule TimemanagerWeb.WorkingTimeController do
  use TimemanagerWeb, :controller

  alias TimemanagerWeb.WorkingTimeController
  alias Timemanager.WorkingTimeContext
  alias Timemanager.WorkingTimeContext.WorkingTime

  action_fallback TimemanagerWeb.FallbackController

  def get_by_user_id_and_id(conn, %{"user_id" => user_id, "id" => id}) do
    workingtime = WorkingTimeContext.get_by_user_id_and_id(user_id, id)
    render(conn, "show.json", working_time: workingtime)
  end


  #def get_by_user_id(conn, %{"user_id" => user_id}) do
    #workingtime = WorkingTimeContext.get_by_user_id(user_id)
    #render(conn, "show.json", working_time: workingtime)
  #end

  def get_by_user_id(conn, %{"user_id" => user_id}) do
    workingtime = WorkingTimeContext.get_by_user_id(user_id)
    conn
    |> put_status(:ok)
    |>render("index.json",workingtime: workingtime)
  end


  def index(conn, _params) do
    workingtime = WorkingTimeContext.list_workingtime()
    render(conn, :index, workingtime: workingtime)
  end

  def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    working_time_params = Map.put(working_time_params, "user_id", user_id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimeContext.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/workingtime/#{working_time.id}")
      |> render(:show, working_time: working_time)
    end
  end



  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = WorkingTimeContext.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- WorkingTimeContext.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = WorkingTimeContext.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- WorkingTimeContext.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
