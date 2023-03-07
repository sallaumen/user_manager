defmodule UserManagerWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :user_manager

  @session_options [
    store: :cookie,
    key: "_user_manager_key",
    signing_salt: "xv0XQkfo",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :user_manager,
    gzip: false,
    only: UserManagerWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :user_manager
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug UserManagerWeb.Router
end
