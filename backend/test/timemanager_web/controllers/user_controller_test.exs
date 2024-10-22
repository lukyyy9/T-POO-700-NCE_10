defmodule TimemanagerWeb.UserControllerTest do
  use TimemanagerWeb.ConnCase

  import Timemanager.UserContextFixtures

  alias Timemanager.UserContext.User

  @create_attrs %{
    username: "some username",
    email: "userTest@example.com"
  }
  @update_attrs %{
    username: "some updated username",
    email: "userTestUpdate@example.com"
  }
  @invalid_attrs %{username: nil, email: nil}

  setup %{conn: conn} do
    # Checkout de la sandbox Ecto pour chaque test et configuration du header JSON
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Timemanager.Repo)
    # Mode partagé pour permettre les connexions dans le même processus
    Ecto.Adapters.SQL.Sandbox.mode(Timemanager.Repo, {:shared, self()})
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup do
      # Nettoyer la base de données avant chaque test
      Timemanager.Repo.delete_all(User)
      users = create_users()
      {:ok, users: users}
    end

    test "lists all users", %{conn: conn, users: users} do
      conn = get(conn, ~p"/api/users")

      assert json_response(conn, 200)["data"] ==
               Enum.map(users, fn user ->
                 %{"id" => user.id, "username" => user.username, "email" => user.email}
               end)
    end

    test "returns empty list when no users exist", %{conn: conn} do
      # Supprimer manuellement les utilisateurs pour simuler une base vide
      Timemanager.Repo.delete_all(User)

      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end

    defp create_users do
      user1 = user_fixture(%{username: "user1", email: "user1@example.com"})
      user2 = user_fixture(%{username: "user2", email: "user2@example.com"})
      [user1, user2]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "userTest@example.com",
               "username" => "some username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "userTestUpdate@example.com",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user.id}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/api/users/#{user.id}")
      end)
    end
  end

  # Helper pour créer un utilisateur avant certains tests
  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
