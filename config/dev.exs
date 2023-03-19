import Config

config :user_manager, UserManager.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "user_manager_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :user_manager, UserManagerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "u8F/ZI6jWaulDpRDTzIY6AjYLiidlIL+KGlQ+nUEPDaXbYIeVv+O9FYAi46LDima",
  watchers: []

config :user_manager, dev_routes: true

config :logger, level: :info, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
