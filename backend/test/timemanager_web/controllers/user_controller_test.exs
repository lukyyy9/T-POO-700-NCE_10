defmodule TimemanagerWeb.UserControllerTest do
  use TimemanagerWeb.ConnCase
  import Mox
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

  @user_context Application.get_env(:timemanager, :user_context)

  setup :verify_on_exit!

  setup %{conn: conn} do
    Mox.stub_with(Timemanager.RepoMock, Timemanager.MockRepo)
    Mox.stub_with(Timemanager.UserContextMock, Timemanager.MockUserContext)
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup_all do
    File.mkdir_p!("backend/test-results")
    :ok
  end

  describe "index" do
    setup do
      users = create_users()
      {:ok, users: users}
    end

    test "lists all users", %{conn: conn, users: users} do
      Mox.expect(@user_context, :list_users, fn -> users end)

      conn = get(conn, ~p"/api/users")

      response = json_response(conn, 200)["data"]
      expected = Enum.map(users, fn user ->
        %{"id" => user.id, "username" => user.username, "email" => user.email}
      end)

      assert response == expected

      File.write!("backend/test-results/user_index_test_result.txt", "User index test passed\n")
    end

    test "returns empty list when no users exist", %{conn: conn} do
      Mox.expect(@user_context, :list_users, fn -> [] end)

      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []

      File.write!("backend/test-results/user_empty_index_test_result.txt", "User empty index test passed\n")
    end

    defp create_users do
      [
        %User{id: 1, username: "user1", email: "user1@example.com"},
        %User{id: 2, username: "user2", email: "user2@example.com"}
      ]
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      Mox.expect(@user_context, :create_user, fn attrs ->
        {:ok, %User{id: 1, username: attrs.username, email: attrs.email}}
      end)

      Mox.expect(@user_context, :get_user!, fn 1 ->
        %User{id: 1, username: @create_attrs.username, email: @create_attrs.email}
      end)

      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "userTest@example.com",
               "username" => "some username"
             } = json_response(conn, 200)["data"]

      File.write!("backend/test-results/user_create_test_result.txt", "User create test passed\n")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      Mox.expect(@user_context, :create_user, fn _attrs ->
        {:error, %Ecto.Changeset{}}
      end)

      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}

      File.write!("backend/test-results/user_create_error_test_result.txt", "User create error test passed\n")
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      Mox.expect(@user_context, :update_user, fn ^user, @update_attrs ->
        {:ok, %User{id: id, username: @update_attrs.username, email: @update_attrs.email}}
      end)

      Mox.expect(@user_context, :get_user!, fn ^id ->
        %User{id: id, username: @update_attrs.username, email: @update_attrs.email}
      end)

      conn = put(conn, ~p"/api/users/#{user.id}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "userTestUpdate@example.com",
               "username" => "some updated username"
             } = json_response(conn, 200)["data"]

      File.write!("backend/test-results/user_update_test_result.txt", "User update test passed\n")
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      Mox.expect(@user_context, :update_user, fn ^user, @invalid_attrs ->
        {:error, %Ecto.Changeset{}}
      end)

      conn = put(conn, ~p"/api/users/#{user.id}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}

      File.write!("backend/test-results/user_update_error_test_result.txt", "User update error test passed\n")
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      Mox.expect(@user_context, :delete_user, fn ^user ->
        {:ok, %User{}}
      end)

      Mox.expect(@user_context, :get_user!, fn _id ->
        raise Ecto.NoResultsError, queryable: User
      end)

      conn = delete(conn, ~p"/api/users/#{user.id}")
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, ~p"/api/users/#{user.id}")
      end)

      File.write!("backend/test-results/user_delete_test_result.txt", "User delete test passed\n")
    end
  end

  defp create_user(_) do
    user = %User{id: 1, username: "test user", email: "test@example.com"}
    %{user: user}
  end
end
