defmodule UserManager.EntityMetadata.EntitiesMetadata do
  require Logger

  alias UserManager.EntityMetadata
  alias UserManager.Repo

  @spec find_by_name(entity_name :: String.t() | atom()) :: EntityMetadata.t() | nil
  def find_by_name(entity_name) do
    Repo.get_by(EntityMetadata, entity_name: entity_name)
  end

  @spec upsert(params :: map()) :: EntityMetadata.t()
  def upsert(params) do
    %EntityMetadata{}
    |> EntityMetadata.changeset(params)
    |> Repo.insert(
      conflict_target: :entity_name,
      on_conflict: {:replace, [:entity_value, :updated_at]},
      returning: true
    )
  end
end
