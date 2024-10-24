defmodule Timemanager.RepoMock do
  Application.put_env(:timemanager, :user_context, Timemanager.UserContextMock)
  alias Timemanager.UserContext.User
  alias Timemanager.ClockContext.Clock

  def all(User) do
    [
      %User{id: 1, username: "user1", email: "user1@example.com"},
      %User{id: 2, username: "user2", email: "user2@example.com"}
    ]
  end

  def all(Clock) do
    [
      %Clock{id: 1, status: true, time: ~N[2023-10-10 10:00:00], user_id: 144},
      %Clock{id: 2, status: false, time: ~N[2023-10-11 11:00:00], user_id: 144}
    ]
  end

  def get(User, id) do
    %User{id: id, username: "test_user", email: "test@example.com"}
  end

  def get(Clock, id) do
    %Clock{id: id, status: true, time: ~N[2023-10-10 10:00:00], user_id: 144}
  end

  def get_by(User, [id: id]) do
    %User{id: id, username: "test_user", email: "test@example.com"}
  end

  def insert(changeset = %Ecto.Changeset{data: %User{}}) do
    user = Ecto.Changeset.apply_changes(changeset)
    {:ok, %User{id: 1, username: user.username, email: user.email}}
  end

  def insert(changeset = %Ecto.Changeset{data: %Clock{}}) do
    clock = Ecto.Changeset.apply_changes(changeset)
    {:ok, %Clock{id: 1, status: clock.status, time: clock.time, user_id: clock.user_id}}
  end

  def update(changeset = %Ecto.Changeset{data: %User{}}) do
    user = Ecto.Changeset.apply_changes(changeset)
    {:ok, %User{id: user.id, username: user.username, email: user.email}}
  end

  def update(changeset = %Ecto.Changeset{data: %Clock{}}) do
    clock = Ecto.Changeset.apply_changes(changeset)
    {:ok, %Clock{id: clock.id, status: clock.status, time: clock.time, user_id: clock.user_id}}
  end

  def delete(%User{id: id}) do
    {:ok, %User{id: id}}
  end

  def delete(%Clock{id: id}) do
    {:ok, %Clock{id: id}}
  end

  def delete_all(User) do
    {2, nil}  # Simule la suppression de 2 utilisateurs
  end

  def delete_all(Clock) do
    {2, nil}  # Simule la suppression de 2 horloges
  end
end
