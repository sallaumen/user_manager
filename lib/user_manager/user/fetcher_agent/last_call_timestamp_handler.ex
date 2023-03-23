defmodule UserManager.User.FetcherAgent.LastCallTimestampHandler do
  alias UserManager.EntityMetadata
  alias UserManager.EntityMetadata.EntitiesMetadata

  @last_server_call_metadata_name :last_time_user_by_min_point_requested

  @spec get_last_and_current_call_datetimes(in_memory_last_call :: String.t() | nil) :: %{
          last_call_datetime: String.t(),
          current_call_datetime: String.t()
        }
  def get_last_and_current_call_datetimes(in_memory_last_call) when is_nil(in_memory_last_call) do
    %{last_call_datetime: get_entity_value_or_nil(), current_call_datetime: get_now_as_string()}
  end

  def get_last_and_current_call_datetimes(in_memory_last_call) do
    %{last_call_datetime: in_memory_last_call, current_call_datetime: get_now_as_string()}
  end

  @spec persist_current_call_datetime(now_as_string :: String.t()) :: EntityMetadata.t()
  def persist_current_call_datetime(now_as_string) do
    EntitiesMetadata.upsert(%{
      entity_name: @last_server_call_metadata_name,
      entity_value: now_as_string,
      updated_at: now_as_string
    })
  end

  defp get_entity_value_or_nil do
    case EntitiesMetadata.find_by_name(@last_server_call_metadata_name) do
      nil -> nil
      entity -> entity.entity_value
    end
  end

  defp get_now_as_string do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
  end
end
