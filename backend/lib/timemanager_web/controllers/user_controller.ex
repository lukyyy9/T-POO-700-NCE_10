defmodule TimemanagerWeb.UserController do
  use TimemanagerWeb, :controller

  alias Timemanager.UserContext
  alias Timemanager.UserContext.User

  action_fallback TimemanagerWeb.FallbackController

  # Action index pour gérer les paramètres de recherche
  def index(conn, %{"email" => email, "username" => username}) do
    user = UserContext.get_by_email_or_username(email, username)
    render(conn, "show.json", user: user)
  end

  def index(conn, _params) do
    users = UserContext.list_users()
    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserContext.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = UserContext.get_user!(id)

    with {:ok, %User{} = user} <- UserContext.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case UserContext.authenticate_user(username, password) do
      {:ok, user} ->
        {:ok, token, _claims} = Timemanager.UserContext.Guardian.encode_and_sign(user, %{})
        conn
        |> put_status(:ok)
        |> json(%{token: token})

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: to_string(reason)})
    end
  end


  def delete(conn, %{"id" => id}) do
    user = UserContext.get_user!(id)

    with {:ok, %User{}} <- UserContext.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
