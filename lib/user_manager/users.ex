defmodule UserManager.Users do
  import Ecto.Query
  alias Ecto.Adapters.SQL
  alias UserManager.Repo
  alias UserManager.User

  @spec fetch_user_by_id(Ecto.UUID.t()) :: {:ok, User.t()} | {:error, String.t()}
  def fetch_user_by_id(id) do
    case Repo.get(User, id) do
      nil -> {:error, "User not found given for ID `#{id}`"}
      user -> {:ok, user}
    end
  end

  @spec find_users_by_min_point(min_point :: integer(), quantity :: integer()) :: list()
  def find_users_by_min_point(min_point, quantity) do
    query =
      from u in User,
        where: u.points > ^min_point,
        limit: ^quantity

    Repo.all(query)
  end

  @spec create_user(attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_user(User.t(), attrs :: map()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%User{} = users, attrs) do
    users
    |> User.changeset(attrs)
    |> Repo.update(stale_error_field: :id)
  end

  @spec update_all_points_in_range_by_max_rand(from_id :: integer(), to_id :: integer(), rand_max_points :: integer()) ::
          {:ok, Postgrex.Result.t()} | {:error, Postgrex.Error.t()}
  def update_all_points_in_range_by_max_rand(from_id, to_id, rand_max_points) do
    batch_update = """
    UPDATE users u
    SET points = points + floor(random() * (#{rand_max_points} + 1)),
        updated_at = '#{get_now_as_second_precision_string()}'
    WHERE u.id >= #{from_id}
      AND u.id <= #{to_id};
    """

    SQL.query(Repo, batch_update, [])
  end

  defp get_now_as_second_precision_string do
    NaiveDateTime.utc_now()
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
  end
end
