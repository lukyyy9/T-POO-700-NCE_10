defmodule Timemanager.UserContext do
  @moduledoc """
  The UserContext context.
  """
  @behaviour Timemanager.UserContextBehaviour

  import Ecto.Query, warn: false
  alias Timemanager.Repo
  alias Timemanager.UserContext.User
  alias Pbkdf2

  @doc """
  Gets a single user by username.
  """
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Gets a single user by email or username.
  """
  def get_by_email_or_username(email, username) do
    query = from(u in User, where: u.email == ^email or u.username == ^username)
    Repo.one(query)
  end

  @doc """
  Returns the list of users.
  """
  def list_users do
    users = Repo.all(User)
    IO.inspect(users)
  end

  @doc """
  Gets a single user.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    IO.inspect(attrs, label: "Attributes")

    %User{}
    |> User.changeset(attrs)
    |> put_password_hash(attrs["password"])
    |> Repo.insert()
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
    |> Repo.update()
  end

  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.username == ^username
    case Repo.one(query) do
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
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Creates an admin user (role = 3).
  """
  @spec create_admin(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_admin(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: 3})
    |> Repo.insert()
  end

  @spec set_admin_role(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def set_admin_role(user) do
    user
    |> User.changeset_role(%{role: 3})
    |> Repo.update()
  end

  @spec create_manager(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_manager(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: 2})
    |> Repo.insert()
  end

  @spec set_manager_role(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def set_manager_role(user) do
    user
    |> User.changeset_role(%{role: 2})
    |> Repo.update()
  end

  def add_user_to_manager_team(manager_id, user_id) do
    case Repo.get(User, user_id) do
      nil ->
        {:error, "User not found"}
      user ->
        changeset = User.changeset(user, %{manager_id: manager_id})

        case Repo.update(changeset) do
          {:ok, updated_user} ->
            {:ok, updated_user}
          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  def get_users_by_manager(manager_id) do
    Repo.all(from u in User, where: u.manager_id == ^manager_id)
  end
end
defmodule Timemanager.UserContext do
  @moduledoc """
  The UserContext context.
  """
  @behaviour Timemanager.UserContextBehaviour

  import Ecto.Query, warn: false
  alias Timemanager.Repo
  alias Timemanager.UserContext.User
  alias Pbkdf2

  @doc """
  Gets a single user by username.
  """
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Gets a single user by email or username.
  """
  def get_by_email_or_username(email, username) do
    query = from(u in User, where: u.email == ^email or u.username == ^username)
    Repo.one(query)
  end

  @doc """
  Returns the list of users.
  """
  def list_users do
    users = Repo.all(User)
    IO.inspect(users)
  end

  @doc """
  Gets a single user.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    IO.inspect(attrs, label: "Attributes")

    %User{}
    |> User.changeset(attrs)
    |> put_password_hash(attrs["password"])
    |> Repo.insert()
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
    |> Repo.update()
  end

  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.username == ^username
    case Repo.one(query) do
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
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Creates an admin user (role = 3).
  """
  @spec create_admin(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_admin(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: 3})
    |> Repo.insert()
  end

  @spec set_admin_role(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def set_admin_role(user) do
    user
    |> User.changeset_role(%{role: 3})
    |> Repo.update()
  end

  @spec create_manager(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_manager(params) do
    %User{}
    |> User.changeset(params)
    |> User.changeset_role(%{role: 2})
    |> Repo.insert()
  end

  @spec set_manager_role(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def set_manager_role(user) do
    user
    |> User.changeset_role(%{role: 2})
    |> Repo.update()
  end

  def add_user_to_manager_team(manager_id, user_id) do
    case Repo.get(User, user_id) do
      nil ->
        {:error, "User not found"}
      user ->
        changeset = User.changeset(user, %{manager_id: manager_id})

        case Repo.update(changeset) do
          {:ok, updated_user} ->
            {:ok, updated_user}
          {:error, reason} ->
            {:error, reason}
        end
    end
  end

  def get_users_by_manager(manager_id) do
    Repo.all(from u in User, where: u.manager_id == ^manager_id)
  end
end
