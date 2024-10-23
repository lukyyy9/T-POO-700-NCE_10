ExUnit.start()

# Start the application
Application.ensure_all_started(:timemanager)

# Define mocks using Mox
Mox.defmock(Timemanager.ClockContextMock, for: Timemanager.ClockContextBehaviour)
Mox.defmock(Timemanager.UserContextMock, for: Timemanager.UserContextBehaviour)

# Set up the mock in the application environment
Application.put_env(:timemanager, :clock_context, Timemanager.ClockContextMock)

# Configure the Ecto sandbox for manual mode
Ecto.Adapters.SQL.Sandbox.mode(Timemanager.Repo, :manual)

# Configure ExUnit with formatters
ExUnit.configure(
  formatters: [
    ExUnit.CLIFormatter,
    JUnitFormatter
  ]
)
