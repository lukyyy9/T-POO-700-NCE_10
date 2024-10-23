defmodule Timemanager.UserContext.Guardian do
  use Guardian, otp_app: :timemanager
  alias Timemanager.UserContext
  require Logger

  # Encode the token with user ID and role
  def subject_for_token(user, _claims) do
    sub = %{
      id: user.id,
      role: user.role
    }
    {:ok, sub}
  end

  # Decode the token and retrieve the user
  def resource_from_claims(%{"sub" => id}) when is_binary(id) do
    # If sub is a string (ID), fetch the user based on the ID directly
    case UserContext.get_user!(id) do
      nil -> {:error, :id_not_found}
      user -> {:ok, user}
    end
  rescue
    Ecto.NoResultsError -> {:error, :id_not_found}
  end

  # Handle the case where sub is a map (for more complex tokens)
  def resource_from_claims(%{"sub" => %{"id" => id}}) do
    case UserContext.get_user!(id) do
      nil -> {:error, :id_not_found}
      user -> {:ok, user}
    end
  rescue
    Ecto.NoResultsError -> {:error, :id_not_found}
  end

  # Extract sub from claims
  defp extract_sub(%{"sub" => sub}) when is_map(sub), do: {:ok, sub}
  defp extract_sub(claims) do
    Logger.error("Invalid sub format in claims: #{inspect(claims)}")
    {:error, :invalid_sub}
  end

  # Extract the ID from the sub
  defp extract_id(%{"id" => id}) when not is_nil(id), do: {:ok, id}
  defp extract_id(sub) do
    Logger.error("ID not found in sub: #{inspect(sub)}")
    {:error, :id_not_found}
  end

  # Fetch the user with the ID
  defp fetch_user(id) when not is_nil(id) do
    case UserContext.get_user(id) do
      nil ->
        Logger.error("User not found with ID: #{inspect(id)}")
        {:error, :user_not_found}
      user -> {:ok, user}
    end
  rescue
    e in Ecto.Query.CastError ->
      Logger.error("ID cast error: #{inspect(e)}")
      {:error, :invalid_id}
  end
end
