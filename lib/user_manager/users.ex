defmodule UserManager.Users do
  import Ecto.Query
  alias Ecto.Multi
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
          Multi.t()
  def update_all_points_in_range_by_max_rand(from_id, to_id, rand_max_points) do
    Multi.new()
    |> Multi.run(:get_users, fn _, _ ->
      {:ok, query_all_in_range(from_id, to_id)}
    end)
    |> Multi.run(:update_users, fn _, %{get_users: users} ->
      result =
        Enum.map(users, fn user ->
          update_user(user, %{points: user.points + generate_random_point_from_zero_to_max(rand_max_points)})
        end)

      {:ok, result}
    end)
    |> Repo.transaction()
  end

  defp query_all_in_range(from_id, to_id), do: Repo.all(from u in User, where: u.id >= ^from_id and u.id <= ^to_id)

  defp generate_random_point_from_zero_to_max(max) do
    :rand.uniform(_range = max + 1) - 1
  end
end
