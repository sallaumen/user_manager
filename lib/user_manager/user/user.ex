defmodule UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  @updatable_fields [:points, :inserted_at, :updated_at]

  @type t :: %__MODULE__{
          id: integer(),
          points: integer,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "users" do
    field :points, :integer

    timestamps()
  end

  def changeset(users, attrs) do
    users
    |> cast(attrs, @updatable_fields)
    |> validate_required(@updatable_fields)
  end
end
