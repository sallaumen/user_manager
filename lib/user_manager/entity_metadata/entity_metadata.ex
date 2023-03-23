defmodule UserManager.EntityMetadata do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer(),
          entity_name: Ecto.Enum,
          entity_value: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @required_fields [:entity_name, :entity_value]
  @possible_metadata [
    :last_time_user_by_min_point_requested
  ]

  schema "entity_metadata" do
    field(:entity_name, Ecto.Enum, values: @possible_metadata)

    field(:entity_value, :string)

    timestamps()
  end

  def changeset(metadata \\ %__MODULE__{}, update_params) do
    metadata
    |> cast(update_params, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:entity_name)
  end
end
