defmodule UserManager.EntityMetadata.EntitiesMetadataTest do
  use UserManager.DataCase, async: false

  alias UserManager.EntityMetadata.EntitiesMetadata
  alias UserManager.Factories.EntityMetadataFactory

  describe "fetch_by_name?/1" do
    test "when metadata exists, should return metadata" do
      metadata = EntityMetadataFactory.insert(:last_time_user_by_min_point_requested)

      assert {:ok, %{entity_name: entity_name}} = EntitiesMetadata.fetch_by_name(:last_time_user_by_min_point_requested)
      assert entity_name == :last_time_user_by_min_point_requested
      refute is_nil(metadata.entity_value)
    end

    test "when metadata does not exist, should return detailed error" do
      assert {:error, "EntityMetadata not found for given entity_name `last_time_user_by_min_point_requested`"} =
               EntitiesMetadata.fetch_by_name(:last_time_user_by_min_point_requested)
    end
  end

  describe "upsert/1" do
    test "when metadata exists, should update metadata value and return" do
      EntityMetadataFactory.insert(:last_time_user_by_min_point_requested, entity_value: "test")
      EntitiesMetadata.upsert(%{entity_name: :last_time_user_by_min_point_requested, entity_value: "test_updated"})

      assert {:ok, %{entity_name: :last_time_user_by_min_point_requested, entity_value: "test_updated"}} =
               EntitiesMetadata.fetch_by_name(:last_time_user_by_min_point_requested)
    end

    test "when metadata does not exist, should create new metadata" do
      EntitiesMetadata.upsert(%{entity_name: :last_time_user_by_min_point_requested, entity_value: "test_updated"})

      assert {:ok, %{entity_name: :last_time_user_by_min_point_requested, entity_value: "test_updated"}} =
               EntitiesMetadata.fetch_by_name(:last_time_user_by_min_point_requested)
    end
  end
end
