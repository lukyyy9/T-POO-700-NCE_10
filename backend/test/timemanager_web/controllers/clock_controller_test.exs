defmodule TimemanagerWeb.ClockControllerTest do
  use TimemanagerWeb.ConnCase
  import Timemanager.ClockContextFixtures
  alias Timemanager.ClockContext.Clock
  alias Timemanager.UserContext.User
  import Mox

  setup :set_mox_global
  setup :verify_on_exit!

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    user = user_fixture()

    create_attrs = %{
      status: true,
      time: NaiveDateTime.utc_now(),
      user_id: user.id
    }

    %{user: user, create_attrs: create_attrs}
  end

  # Créer le répertoire pour les résultats si nécessaire
  setup_all do
    File.mkdir_p!("backend/test-results")
    :ok
  end

  describe "index" do
    test "lists all clocks", %{conn: conn} do
      clock1 = %Clock{id: 1, status: true, time: ~N[2023-10-10 10:00:00], user_id: 144}
      clock2 = %Clock{id: 2, status: false, time: ~N[2023-10-11 11:00:00], user_id: 144}
      Mox.expect(Timemanager.ClockContextMock, :list_clocks, fn -> [clock1, clock2] end)

      conn = get(conn, ~p"/api/clocks")

      expected_response = [
        %{"id" => 1, "status" => true, "time" => "2023-10-10T10:00:00", "user_id" => 144},
        %{"id" => 2, "status" => false, "time" => "2023-10-11T11:00:00", "user_id" => 144}
      ]

      assert json_response(conn, 200)["data"] == expected_response
      # Écrire le résultat dans un fichier
      File.write!("backend/test-results/index_test_result.txt", "Index test passed\n")
    end
  end

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn, create_attrs: create_attrs, user: user} do
      user_id = create_attrs.user_id

      Mox.expect(Timemanager.ClockContextMock, :get_last_clocking, fn ^user_id ->
        nil
      end)

      Mox.expect(Timemanager.ClockContextMock, :create_clock, fn _params ->
        {:ok, %Clock{id: 1, status: true, time: ~N[2023-10-10 10:00:00], user_id: user_id}}
      end)

      Mox.expect(Timemanager.ClockContextMock, :get_by_user_id, fn ^user_id ->
        [%Clock{id: 1, status: true, time: ~N[2023-10-10 10:00:00], user_id: user_id}]
      end)

      conn = post(conn, ~p"/api/clocks/#{user_id}", clock: create_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/clocks/#{user_id}")

      response_data = json_response(conn, 200)["data"]

      # Afficher explicitement les valeurs pour débogage
      IO.inspect(response_data, label: "Response Data")
      IO.inspect(user_id, label: "Expected User ID")

      assert [
               %{
                 "id" => ^id,
                 "status" => true,
                 "time" => "2023-10-10T10:00:00",
                 "user_id" => ^user_id
               }
             ] = response_data

      # Écrire le résultat dans un fichier
      File.write!(
        "backend/test-results/create_clock_result.txt",
        "Create clock test passed with ID #{id}\n"
      )
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      invalid_attrs = %{status: nil, time: nil, user_id: nil}

      Mox.expect(Timemanager.ClockContextMock, :get_last_clocking, fn _user_id ->
        nil
      end)

      Mox.expect(Timemanager.ClockContextMock, :create_clock, fn _params ->
        {:error,
         %Ecto.Changeset{
           errors: [
             status: {"can't be blank", []},
             time: {"can't be blank", []},
             user_id: {"can't be blank", []}
           ]
         }}
      end)

      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: invalid_attrs)
      assert %{"errors" => errors} = json_response(conn, 422)
      # Écrire le résultat dans un fichier d'erreurs
      File.write!(
        "backend/test-results/create_clock_error_result.txt",
        "Create clock test failed with errors #{inspect(errors)}\n"
      )

      assert errors != %{}
    end
  end

  test "deletes chosen clock", %{conn: conn, user: user} do
    # Assurez-vous que c'est un entier
    clock_id = 1
    user_id = user.id

    # Simuler la récupération de l'horloge
    Mox.expect(Timemanager.ClockContextMock, :get_clock, fn ^clock_id ->
      %Clock{id: clock_id, status: true, time: ~N[2023-10-10 10:00:00], user_id: user_id}
    end)

    # Simuler la récupération des horloges par user_id avant la suppression
    Mox.expect(Timemanager.ClockContextMock, :get_by_user_id, fn ^user_id ->
      [%Clock{id: clock_id, status: true, time: ~N[2023-10-10 10:00:00], user_id: user_id}]
    end)

    # Vérifier que l'horloge existe avant la suppression
    conn = get(conn, ~p"/api/clocks/#{user_id}")
    assert [%{"id" => ^clock_id}] = json_response(conn, 200)["data"]

    # Simuler une suppression réussie
    Mox.expect(Timemanager.ClockContextMock, :delete_clock, fn %Clock{id: ^clock_id} ->
      {:ok, %Clock{id: clock_id, status: true, time: ~N[2023-10-10 10:00:00], user_id: user_id}}
    end)

    # Effectuer la requête de suppression
    # Assurez-vous que clock_id est un entier ici
    conn = delete(conn, ~p"/api/clocks/#{clock_id}")
    assert response(conn, 204)

    # Simuler la récupération des horloges par user_id après la suppression
    Mox.expect(Timemanager.ClockContextMock, :get_by_user_id, fn ^user_id -> [] end)

    # Vérifier que l'horloge n'existe plus
    conn = get(conn, ~p"/api/clocks/#{user_id}")
    assert json_response(conn, 200)["data"] == []

    # Écrire le résultat de la suppression dans un fichier
    File.write!(
      "backend/test-results/delete_clock_result.txt",
      "Delete clock test passed for ID #{clock_id}\n"
    )
  end

  describe "update clock" do
    test "updates chosen clock when data is valid", %{
      conn: conn,
      create_attrs: create_attrs,
      user: user
    } do
      user_id = create_attrs.user_id

      Mox.expect(Timemanager.ClockContextMock, :get_clock!, fn _id ->
        %Clock{id: 1, status: true, time: ~N[2023-10-10 10:00:00], user_id: user_id}
      end)

      Mox.expect(Timemanager.ClockContextMock, :update_clock, fn _clock, _params ->
        {:ok, %Clock{id: 1, status: false, time: ~N[2023-10-11 11:00:00], user_id: user_id}}
      end)

      update_attrs = %{
        status: false,
        time: ~N[2023-10-11 11:00:00],
        user_id: user_id
      }

      conn = put(conn, ~p"/api/clocks/1", clock: update_attrs)
      assert %{"id" => 1} = json_response(conn, 200)["data"]

      Mox.expect(Timemanager.ClockContextMock, :get_by_user_id, fn _user_id ->
        [%Clock{id: 1, status: false, time: ~N[2023-10-11 11:00:00], user_id: user_id}]
      end)

      conn = get(conn, ~p"/api/clocks/#{user_id}")

      assert [
               %{
                 "id" => 1,
                 "status" => false,
                 "time" => "2023-10-11T11:00:00"
               }
             ] = json_response(conn, 200)["data"]

      # Écrire le résultat de la mise à jour dans un fichier
      File.write!(
        "backend/test-results/update_clock_result.txt",
        "Update clock test passed for ID #{id}\n"
      )
    end

    test "renders errors when data is invalid", %{
      conn: conn,
      create_attrs: create_attrs,
      user: user
    } do
      user_id = create_attrs.user_id

      Mox.expect(Timemanager.ClockContextMock, :get_clock!, fn _id ->
        %Clock{id: 1, status: true, time: ~N[2023-10-10 10:00:00], user_id: user_id}
      end)

      Mox.expect(Timemanager.ClockContextMock, :update_clock, fn _clock, _params ->
        {:error,
         %Ecto.Changeset{
           errors: [
             status: {"can't be blank", []},
             time: {"can't be blank", []},
             user_id: {"can't be blank", []}
           ]
         }}
      end)

      invalid_update_attrs = %{
        status: nil,
        time: nil,
        user_id: nil
      }

      conn = put(conn, ~p"/api/clocks/1", clock: invalid_update_attrs)
      assert %{"errors" => errors} = json_response(conn, 422)
      assert errors != %{}

      # Écrire le résultat d'erreur de mise à jour dans un fichier
      File.write!(
        "backend/test-results/update_clock_error_result.txt",
        "Update clock test failed with errors #{inspect(errors)}\n"
      )
    end
  end
end
