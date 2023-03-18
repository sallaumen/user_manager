defmodule UserManager.User.Updater do
  import Ecto.Query
  alias UserManager.Repo
  alias UserManager.User

  @batch_size 2
  @max_update_point 100
  @min_update_point 0

  def update_all_points do
    num_batches = count_number_of_batches()

    Enum.map(0..num_batches, fn batch ->
      #      offset = batch * @batch_size
      rand = generate_random_point_from_zero_to_max(@max_update_point)
      IO.inspect(rand)
      #      query =
      #        from(u in User,
      #          limit: @batch_size,
      #          offset: 5,
      #          update: [set: [points: u.points + ^rand]]
      #        )
      #
      #      Repo.update_all(
      #        query,
      #        []
      #      )
    end)

    #    query =
    #      from(
    #        f in Folder,
    #        where: is_nil(f.workspace_id),
    #        update: [set: [workspace_id: w.id]],
    #        limit: 1, offset: 0
    #      )
    #
    #    Repo.update_all(query, [])
  end

  defp generate_random_point_from_zero_to_max(max) do
    :rand.uniform(_range = max + 1) - 1
  end

  defp count_number_of_batches do
    table_size = Repo.aggregate(User, :count, :id) |> IO.inspect()

    (table_size / @batch_size)
    |> Float.ceil(0)
    |> trunc()
  end
end
