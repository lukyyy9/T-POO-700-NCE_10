defmodule Timemanager.UserContext.Guardian do
  use Guardian, otp_app: :timemanager

  alias ElixirLS.LanguageServer.Plugins.Ecto
  alias Timemanager.UserContext

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    user = UserContext.get_user!(id)
    {:ok, user}

  rescue
    Ecto.NoResultsError -> {:error, :resource_not_found}
  end
end
