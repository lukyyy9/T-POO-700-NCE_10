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
    Mox.stub_with(Timemanager.RepoMock, Timemanager.MockRepo)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
  setup_all do
    # Créer le répertoire pour les résultats des tests
    File.mkdir_p!("backend/test-results")
    :ok
  end

  describe "index" do
    setup do
      Timemanager.RepoMock.delete_all(User)
      users = create_users()
      {:ok, users: users}
    end

    test "lists all users", %{conn: conn, users: users} do
      conn = get(conn, ~p"/api/users")

      response = json_response(conn, 200)["data"]
      expected = Enum.map(users, fn user ->
        %{"id" => user.id, "username" => user.username, "email" => user.email}
      end)

      assert response == expected

      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/user_index_test_result.txt", "User index test passed\n")
      if File.exists?("backend/test-results/user_index_test_result.txt") do
        IO.puts("Fichier écrit avec succès")
      else
        IO.puts("Échec de l'écriture du fichier")
      end
    end

    test "returns empty list when no users exist", %{conn: conn} do
      Timemanager.RepoMock.delete_all(User)

      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []

      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/user_empty_index_test_result.txt", "User empty index test passed\n")
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

      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/user_create_test_result.txt", "User create test passed\n")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}

      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/user_create_error_test_result.txt", "User create error test passed\n")
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

      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/user_update_test_result.txt", "User update test passed\n")
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user.id}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}

      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/user_update_error_test_result.txt", "User update error test passed\n")
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

      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/user_delete_test_result.txt", "User delete test passed\n")
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
