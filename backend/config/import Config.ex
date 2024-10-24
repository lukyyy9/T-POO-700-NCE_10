import Config

# Configure your database
# Note: For mocked tests, you might not need this database configuration
# config :timemanager, Timemanager.Repo,
#   username: "postgres",
#   password: "pwd",
#   hostname: "10.73.189.233",
#   database: "timemanager_test#{System.get_env("MIX_TEST_PARTITION")}",
#   pool: Ecto.Adapters.SQL.Sandbox,
#   pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :timemanager, TimemanagerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "cnpXMIRaseCrNtYVtym/ELaXoku9MF1fOXhFi3oSfFQM48+9K7T6GF8wiWC9woVO",
  server: true

# In test we don't send emails
config :timemanager, Timemanager.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Use the mock for ClockContext
config :timemanager, :clock_context, Timemanager.ClockContextMock

# If you're using Mox for mocking
config :timemanager, :mox_adapter, Mox

# Configure ExUnit
ExUnit.configure(
  formatters: [
    ExUnit.CLIFormatter,
    JUnitFormatter
  ]
)

JUnitFormatter.configure(
  report_dir: "/app/test-results",
  report_file: "results.xml"
)

ExUnit.start()
