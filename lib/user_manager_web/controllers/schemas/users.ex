defmodule UserManagerWeb.Controllers.Schemas.Users do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          min_number: integer
        }

  embedded_schema do
    field(:min_number, :integer)
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:min_number])
  end
end
