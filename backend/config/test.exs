import Config

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


# Configuration for JUnitFormatter
config :junit_formatter,
  report_dir: "/app/test-results",
  report_file: "results.xml",
  print_report_file: true,
  prepend_project_name?: true,
  include_filename?: true,
  include_file_line?: true
