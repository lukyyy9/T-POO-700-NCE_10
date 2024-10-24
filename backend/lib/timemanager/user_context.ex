defmodule Timemanager.UserContext do
  @moduledoc """
  The UserContext context.
  """
  @behaviour Timemanager.UserContextBehaviour

  import Ecto.Query, warn: false
  @repo Application.get_env(:timemanager, :repo)
  alias Timemanager.UserContext.User
  alias Pbkdf2

  @doc """
  Gets a single user by username.
  """
  def get_user_by_username(username) do
    @repo.get_by(User, username: username)
  end

  @doc """
  Gets a single user by email or username.
  """
  def get_by_email_or_username(email, username) do
    query = from(u in User, where: u.email == ^email or u.username == ^username)
    @repo.one(query)
  end

  @doc """
  Returns the list of users.
  """
  def list_users do
    @repo.all(User)
  end

  @doc """
  Gets a single user.
  """
  def get_user!(id), do: @repo.get!(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    IO.inspect(attrs, label: "Attributes")

    %User{}
    |> User.changeset(attrs)
    |> put_password_hash(attrs["password"])
    |> @repo.insert()
  end

  defp put_password_hash(changeset, nil), do: changeset
  defp put_password_hash(changeset, password) do
    hash = Pbkdf2.add_hash(password)
    Ecto.Changeset.put_change(changeset, :password_hash, hash.password_hash)
  end

  @doc """
  Updates a user.
  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> @repo.update()
  end

  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.username == ^username
    case @repo.one(query) do
      nil ->
        Pbkdf2.no_user_verify()
        {:error, :invalid_credentials}
      user ->
        if Pbkdf2.verify_pass(plain_text_password, user.password_hash) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    @repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end
end
