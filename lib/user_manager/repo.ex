defmodule UserManager.Repo do
  use Ecto.Repo,
    otp_app: :user_manager,
    adapter: Ecto.Adapters.Postgres
end
