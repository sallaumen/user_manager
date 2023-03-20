defmodule UserManager.Factories.EntityMetadataFactory do
  use ExMachina.Ecto, repo: UserManager.Repo
  alias Faker.Lorem.Shakespeare.En
  alias UserManager.EntityMetadata

  def last_time_user_by_min_point_requested_factory do
    %EntityMetadata{
      entity_name: :last_time_user_by_min_point_requested,
      entity_value: NaiveDateTime.utc_now() |> NaiveDateTime.to_string()
    }
  end

  def generic_factory do
    %EntityMetadata{
      entity_name: nil,
      entity_value: "test"
    }
  end
end
