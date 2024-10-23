defmodule Timemanager.Plugs.EnsureAdminRole do
  import Plug.Conn
  require Logger
  alias Phoenix.Controller

  def init(default), do: default

  def call(conn, _default) do
    with {:ok, claims} <- get_claims(conn),
         {:ok, role} <- extract_role(claims) do

      Logger.debug("Vérification du rôle admin. Claims: #{inspect(claims)}")

      if role == 3 do
        Logger.debug("Accès admin autorisé. Rôle: #{inspect(role)}")
        conn
      else
        Logger.warn("Tentative d'accès non autorisée. Rôle: #{inspect(role)}")
        conn
        |> put_status(:forbidden)
        |> Controller.json(%{error: "Admin access required"})
        |> halt()
      end
    else
      error ->
        Logger.error("Erreur d'authentification: #{inspect(error)}")
        conn
        |> put_status(:unauthorized)
        |> Controller.json(%{error: "Invalid authentication"})
        |> halt()
    end
  end

  defp get_claims(conn) do
    claims = Guardian.Plug.current_claims(conn)
    Logger.debug("Claims reçus: #{inspect(claims)}")

    case claims do
      %{} -> {:ok, claims}
      nil -> {:error, :no_claims_found}
    end
  end

  defp extract_role(%{"sub" => %{"role" => role}}) when is_integer(role), do: {:ok, role}
  defp extract_role(%{"sub" => sub}) when is_map(sub) do
    Logger.error("Role non trouvé dans sub: #{inspect(sub)}")
    {:error, :role_not_found}
  end
  defp extract_role(claims) do
    Logger.error("Format de claims invalide: #{inspect(claims)}")
    {:error, :invalid_claims}
  end
end
