ExUnit.start()

# Charger tous les fichiers du répertoire support
Path.wildcard("test/support/**/*.ex")
|> Enum.each(&Code.require_file/1)

# Start the application
Application.ensure_all_started(:timemanager)

# Define mocks using Mox

Mox.defmock(Timemanager.ClockContextMock, for: Timemanager.ClockContextBehaviour)
Mox.defmock(Timemanager.UserContextMock, for: Timemanager.UserContextBehaviour)
Mox.defmock(Timemanager.RepoMock, for: Ecto.Repo)

Code.require_file("test/support/mock_repo.ex")

setup :set_mox_global

# Set up the mock in the application environment
Application.put_env(:timemanager, :user_context, Timemanager.UserContextMock)
Application.put_env(:timemanager, :clock_context, Timemanager.ClockContextMock)
Application.put_env(:timemanager, :repo, Timemanager.RepoMock)

# Configure the Ecto sandbox for manual mode
# Ecto.Adapters.SQL.Sandbox.mode(Timemanager.Repo, :manual)

# Configure ExUnit with formatters
ExUnit.configure(
  formatters: [
    ExUnit.CLIFormatter,
    JUnitFormatter
  ]
)
