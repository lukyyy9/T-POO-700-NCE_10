defmodule Timemanager.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Timemanager.Repo
  alias Timemanager.UserContext.User
  alias Pbkdf2

  @doc """
  Gets a single user by username.

  ## Examples

      iex> get_user_by_username("username")
      %User{}

  """
  def get_user_by_username(username) do
    Repo.get_by(User, username: username)
  end

  @doc """
  Gets a single user by email or username.

  ## Examples

      iex> get_by_email_or_username("email", "username")
      %User{}

  """
  def get_by_email_or_username(email, username) do
    query = from(u in User, where: u.email == ^email or u.username == ^username)
    Repo.one(query)
  end

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    IO.inspect(attrs, label: "Attributes")

    %User{}
    |> User.changeset(attrs)
    |> put_password_hash(attrs["password"])  # Correctly handle password
    |> Repo.insert()
  end

  defp put_password_hash(changeset, nil), do: changeset
  defp put_password_hash(changeset, password) do
    hash = Pbkdf2.add_hash(password)
    Ecto.Changeset.put_change(changeset, :password_hash, hash.password_hash)
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

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

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
 @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  defmodule Timemanager.UserContext do

    # Function to change user attributes
    def change_user(%User{} = user, attrs \\ %{}) do
      User.changeset(user, attrs)
    end

    # Function to create an admin user (role = 3)
    @spec create_admin(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
    def create_admin(params) do
      %User{}
      |> User.changeset(params)
      |> User.changeset_role(%{role: 3})  # Admin role as 3
      |> Repo.insert()
    end

    # Function to set an existing user as admin (role = 3)
    @spec set_admin_role(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
    def set_admin_role(user) do
      user
      |> User.changeset_role(%{role: 3})  # Admin role as 3
      |> Repo.update()
    end

    # Function to create a manager user (role = 2)
    @spec create_manager(map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
    def create_manager(params) do
      %User{}
      |> User.changeset(params)
      |> User.changeset_role(%{role: 2})  # Manager role as 2
      |> Repo.insert()
    end

    # Function to set an existing user as manager (role = 2)
    @spec set_manager_role(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
    def set_manager_role(user) do
      user
      |> User.changeset_role(%{role: 2})  # Manager role as 2
      |> Repo.update()
    end
  end
end
