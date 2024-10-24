defmodule Timemanager.UserContextFixtures do
  import Mox
  alias Timemanager.UserContext.User

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Timemanager.UserContext` context.
  """

  @user_context Application.get_env(:timemanager, :user_context)

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    attrs = Enum.into(attrs, %{
      email: "userTest@example.com",
      username: "some username"
    })

    expect(@user_context, :create_user, fn ^attrs ->
      {:ok, struct(User, Map.put(attrs, :id, System.unique_integer([:positive])))}
    end)

    {:ok, user} = @user_context.create_user(attrs)

    user
  end
end
