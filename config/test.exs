import Config

config :user_manager, UserManager.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "user_manager_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :user_manager, UserManagerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "fq3U2QEDjeSVLeGThUwhZLHyfuzICxwqwGlD+s54CAJThLIIzs5OI8aeVXbaFK5J",
  server: false

config :logger, level: :warning

config :phoenix, :plug_init_mode, :runtime
