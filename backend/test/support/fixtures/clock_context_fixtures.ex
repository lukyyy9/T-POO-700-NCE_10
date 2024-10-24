defmodule Timemanager.ClockContextFixtures do
  import Mox
  alias Timemanager.UserContext.User
  alias Timemanager.ClockContext.Clock

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.ClockContext` context.
  """

  @user_context Application.get_env(:timemanager, :user_context)
  @clock_context Application.get_env(:timemanager, :clock_context)

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    user = user_fixture()  # Crée un utilisateur valide
    now = NaiveDateTime.utc_now()  # Obtenir la date et l'heure actuelles

    # Ajouter l'ID de l'utilisateur et générer la date dynamique dans les attributs
    attrs = Map.put(attrs, :user_id, user.id)

    # Fusionner les attributs fournis avec les valeurs par défaut, y compris la date actuelle
    clock_attrs = Enum.into(attrs, %{
      status: true,
      time: now  # Utilise la date actuelle pour le champ 'time'
    })

    expect(@clock_context, :create_clock, fn ^clock_attrs ->
      {:ok, struct(Clock, Map.put(clock_attrs, :id, System.unique_integer([:positive])))}
    end)

    {:ok, clock} = @clock_context.create_clock(clock_attrs)

    clock
  end

  def user_fixture(attrs \\ %{}) do
    # Création d'un utilisateur avec des attributs par défaut ou ceux fournis
    default_attrs = %{
      username: "test_user",
      email: "test@example.com",
    }

    attrs = Enum.into(attrs, default_attrs)

    expect(@user_context, :create_user, fn ^attrs ->
      {:ok, struct(User, Map.put(attrs, :id, System.unique_integer([:positive])))}
    end)

    {:ok, user} = @user_context.create_user(attrs)
    user
  end
end
