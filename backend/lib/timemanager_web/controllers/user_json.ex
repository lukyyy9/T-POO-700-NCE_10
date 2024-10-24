defmodule TimemanagerWeb.UserJSON do
  alias Timemanager.UserContext.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders an error message when a user is not found.
  """
  def show(%{user: nil}) do
    %{errors: %{detail: "User not found"}}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role
    }
  end
end
