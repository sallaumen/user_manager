defmodule UserManager.User.FetcherAgent do
  use GenServer, shutdown: 100_000
  require Logger
  alias UserManager.User.FetcherAgent.LastCallTimestampHandler
  alias UserManager.Users

  def start_link(opts \\ []) do
    case GenServer.start_link(__MODULE__, opts, name: __MODULE__) do
      success = {:ok, _pid} ->
        success

      err = {:error, reason} ->
        Logger.error("Failed stating `#{__MODULE__}` Genserver. Error: #{inspect(reason)}")
        err
    end
  end

  @impl true
  def init(_) do
    {:ok, {_last_call_min_point = nil, _last_call_datetime = nil}}
  end

  def get_users_by_min_points(min_point, quantity) do
    GenServer.call(__MODULE__, {:get_two_above_minimum_points, min_point, quantity})
  end

  @impl true
  def handle_call({:get_two_above_minimum_points, min_point, quantity}, _from, {_, last_call_timestamp}) do
    %{last_call_datetime: last_call, current_call_datetime: now} =
      LastCallTimestampHandler.get_last_and_current_call_datetimes(last_call_timestamp)

    LastCallTimestampHandler.persist_current_call_datetime(now)

    output = %{
      users: Users.find_users_by_min_point(min_point, quantity),
      last_call: last_call
    }

    {:reply, output, {min_point, now}}
  end
end
