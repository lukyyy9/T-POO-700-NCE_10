defmodule Timemanager.ClockContextFixtures do
  alias Timemanager.Repo
  alias Timemanager.UserContext.User

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.ClockContext` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    user = user_fixture()  # Crée un utilisateur valide
    now = NaiveDateTime.utc_now()  # Obtenir la date et l'heure actuelles

    # Ajouter l'ID de l'utilisateur et générer la date dynamique dans les attributs
    attrs = Map.put(attrs, :user_id, user.id)

    # Fusionner les attributs fournis avec les valeurs par défaut, y compris la date actuelle
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: now  # Utilise la date actuelle pour le champ 'time'
      })
      |> Timemanager.ClockContext.create_clock()

    clock
  end


  def user_fixture(attrs \\ %{}) do
    # Création d'un utilisateur avec des attributs par défaut ou ceux fournis
    default_attrs = %{
      username: "test_user",
      email: "test@example.com",
    }

    attrs = Enum.into(attrs, default_attrs)  # Fusionne les attributs par défaut avec ceux fournis

    {:ok, user} = Timemanager.UserContext.create_user(attrs)
    user
  end
end
