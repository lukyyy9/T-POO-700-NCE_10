defmodule Timemanager.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset
  @derive {Jason.Encoder, only: [:id, :username, :email, :role, :manager_id, :inserted_at, :updated_at]}
  schema "users" do
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :role, :integer, default: 1
    belongs_to :manager, Timemanager.UserContext.User, foreign_key: :manager_id # Ajoute la relation avec manager


    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :password, :role, :manager_id])
    |> validate_required([:username, :email, :role])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case get_change(changeset, :password) do
      nil -> changeset
      password ->
        hash = Pbkdf2.add_hash(password)
        put_change(changeset, :password_hash, hash.password_hash)
    end
  end

  @spec changeset_role(Ecto.Schema.t() | Ecto.Changeset.t(), map()) :: Ecto.Changeset.t()
  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, [1,2,3])
  end
end
