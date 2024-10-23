# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Timemanager.Repo.insert!(%Timemanager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Timemanager.Repo
alias Timemanager.UserContext.User
alias Timemanager.UserContext


admin_exists = Repo.get_by(User, username: "admin")


if admin_exists do
  IO.puts("Admin user already exists")
else
  %{
    "username" => "admin",
    "email" => "route@admin.com",
    "password" => "route123",
    "role" => 3
  }
  |> UserContext.create_user()
  |> case do
    {:ok, _user} -> IO.puts("Admin user created successfully")
    {:error, reason} -> IO.puts("Failed to create admin user: #{inspect(reason)}")
  end
end
