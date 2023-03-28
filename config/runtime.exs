import Config

if config_env() == :prod do
  config :user_manager, UserManager.Repo,
    url: System.fetch_env!("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    timeout: 25_000

  host = System.fetch_env!("PHX_HOST")
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :user_manager, UserManagerWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE")

  config :user_manager, UserManager.QuantumScheduler,
    debug_logging: true,
    overlap: false,
    jobs: [
      {"* * * * *", {UserManager.User.PointsUpdater, :update_all_points, []}}
    ]
end
