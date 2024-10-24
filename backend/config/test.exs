import Config

# Configuration de l'endpoint
config :timemanager, TimemanagerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "cnpXMIRaseCrNtYVtym/ELaXoku9MF1fOXhFi3oSfFQM48+9K7T6GF8wiWC9woVO",
  server: false  # Changez ceci à false sauf si vous avez besoin d'un vrai serveur pour vos tests

# Configuration des mocks
config :timemanager, :clock_context, Timemanager.ClockContextMock
config :timemanager, :user_context, Timemanager.UserContextMock
config :timemanager, :repo, Timemanager.RepoMock

# Supprimez ou commentez toute configuration liée à une vraie base de données
# config :timemanager, Timemanager.RepoMock,
#   adapter: Ecto.Adapters.SQLite3,
#   database: ":memory:",
#   pool: Ecto.Adapters.SQL.Sandbox

# Autres configurations
config :timemanager, Timemanager.Mailer, adapter: Swoosh.Adapters.Test
config :swoosh, :api_client, false
config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime
config :timemanager, :mox_adapter, Mox

# Configuration pour JUnitFormatter
config :junit_formatter,
  report_dir: "/app/test-results",
  report_file: "results.xml",
  print_report_file: true,
  prepend_project_name?: true,
  include_filename?: true,
  include_file_line?: true
