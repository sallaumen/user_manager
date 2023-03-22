defmodule UserManager.User.FetcherAgent do
  use GenServer, shutdown: 100_000
  alias UserManager.EntityMetadata.EntitiesMetadata
  alias UserManager.Users

  @last_server_call_metadata_name :last_time_user_by_min_point_requested

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    {:ok, opts}
  end

  def get_users_by_min_points(min_point, quantity) do
    GenServer.call(__MODULE__, {:get_two_above_minimum_points, min_point, quantity})
  end

  @impl true
  def handle_call({:get_two_above_minimum_points, min_point, quantity}, _from, state) do
    output = %{
      users: Users.find_users_by_min_point(min_point, quantity),
      last_call: get_last_call_datetime_and_update_it_after()
    }

    {:reply, output, state}
  end

  defp get_last_call_datetime_and_update_it_after do
    response =
      case EntitiesMetadata.fetch_by_name(@last_server_call_metadata_name) do
        {:ok, value} -> value.entity_value
        {:error, _} -> nil
      end

    update_last_call_datetime()

    response
  end

  defp update_last_call_datetime do
    EntitiesMetadata.upsert(%{
      entity_name: @last_server_call_metadata_name,
      entity_value: get_now_as_string(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  defp get_now_as_string do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
  end
end
