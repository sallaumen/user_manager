defmodule UserManager.Application do
  use Application

  @impl true
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: UserManager.Supervisor]
    Supervisor.start_link(get_children(), opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    UserManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp get_children do
    :user_manager
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:application_children)
  end
end
