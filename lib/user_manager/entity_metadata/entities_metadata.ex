defmodule UserManager.EntityMetadata.EntitiesMetadata do
  require Logger

  alias UserManager.EntityMetadata
  alias UserManager.Repo

  def fetch_by_name(entity_name) do
    case Repo.get_by(EntityMetadata, entity_name: entity_name) do
      nil -> {:error, "EntityMetadata not found for given entity_name `#{entity_name}`"}
      entity -> {:ok, entity}
    end
  end

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
