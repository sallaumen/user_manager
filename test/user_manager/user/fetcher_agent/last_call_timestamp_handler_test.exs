defmodule UserManager.User.FetcherAgent.LastCallTimestampHandlerTest do
  use UserManager.DataCase, async: true
  alias UserManager.Factories.EntityMetadataFactory
  alias UserManager.User.FetcherAgent.LastCallTimestampHandler

  describe "get_last_and_current_call_datetimes/1" do
    test "when in_memory_last_call is not nil, should return last_call and now as string, formatted as map" do
      in_memory_last_call = NaiveDateTime.utc_now()

      %{last_call_datetime: in_memory_last_call_return, current_call_datetime: now_as_string} =
        LastCallTimestampHandler.get_last_and_current_call_datetimes(in_memory_last_call)

      assert in_memory_last_call == in_memory_last_call_return

      assert now_as_string ==
               NaiveDateTime.utc_now()
               |> NaiveDateTime.truncate(:second)
               |> NaiveDateTime.to_string()
    end

    test "when in_memory_last_call is nil, should get entity_metadata value from database as fallback, formatted as map" do
      inserted_time = NaiveDateTime.to_string(NaiveDateTime.utc_now())
      EntityMetadataFactory.insert(:last_time_user_by_min_point_requested, entity_value: inserted_time)
      :timer.sleep(1_000)

      %{last_call_datetime: last_call_return, current_call_datetime: now_as_string} =
        LastCallTimestampHandler.get_last_and_current_call_datetimes(nil)

      assert last_call_return == inserted_time

      assert now_as_string ==
               NaiveDateTime.utc_now()
               |> NaiveDateTime.truncate(:second)
               |> NaiveDateTime.to_string()
    end
  end

  describe "persist_current_call_datetime/1" do
    test "when metadata exists, should update metadata value and return updated" do
      now = NaiveDateTime.utc_now()
      now_as_string = NaiveDateTime.to_string(now)
      trunc_now = NaiveDateTime.truncate(now, :second)

      EntityMetadataFactory.insert(:last_time_user_by_min_point_requested, entity_value: "test")

      assert {:ok,
              %{
                entity_name: :last_time_user_by_min_point_requested,
                entity_value: ^now_as_string,
                updated_at: ^trunc_now
              }} = LastCallTimestampHandler.persist_current_call_datetime(now_as_string)
    end

    test "when metadata does not exist, should create new metadata" do
      now = NaiveDateTime.utc_now()
      now_as_string = NaiveDateTime.to_string(now)
      trunc_now = NaiveDateTime.truncate(now, :second)

      assert {:ok,
              %{
                entity_name: :last_time_user_by_min_point_requested,
                entity_value: ^now_as_string,
                updated_at: ^trunc_now
              }} = LastCallTimestampHandler.persist_current_call_datetime(now_as_string)
    end
  end
end
