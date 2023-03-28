defmodule UserManager.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:points]
  @optional_fields [:inserted_at, :updated_at]

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
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
