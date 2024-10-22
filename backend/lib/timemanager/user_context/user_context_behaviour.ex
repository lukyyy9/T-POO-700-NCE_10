defmodule Timemanager.UserContextBehaviour do
  @moduledoc """
  Defines the behaviour for the UserContext.
  """

  @callback get_by_email_or_username(String.t(), String.t()) :: %Timemanager.UserContext.User{} | nil
  @callback list_users() :: [%Timemanager.UserContext.User{}]
  @callback get_user!(integer) :: %Timemanager.UserContext.User{} | no_return
  @callback create_user(map) :: {:ok, %Timemanager.UserContext.User{}} | {:error, Ecto.Changeset.t()}
  @callback update_user(%Timemanager.UserContext.User{}, map) :: {:ok, %Timemanager.UserContext.User{}} | {:error, Ecto.Changeset.t()}
  @callback delete_user(%Timemanager.UserContext.User{}) :: {:ok, %Timemanager.UserContext.User{}} | {:error, Ecto.Changeset.t()}
  @callback change_user(%Timemanager.UserContext.User{}, map) :: Ecto.Changeset.t()
end
