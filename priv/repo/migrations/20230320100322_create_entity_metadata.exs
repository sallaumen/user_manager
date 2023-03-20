defmodule UserManager.Repo.Migrations.CreateEntityMetadata do
  use Ecto.Migration

  def change do
    create table(:entity_metadata) do
      add :entity_name, :string, null: false
      add :entity_value, :string, null: false

      timestamps()
    end

    create unique_index("entity_metadata", [:entity_name])
  end
end
