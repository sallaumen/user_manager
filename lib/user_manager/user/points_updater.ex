defmodule UserManager.User.PointsUpdater do
  require Logger

  alias UserManager.Repo
  alias UserManager.User
  alias UserManager.Users

  @batch_size 5000
  @max_update_point 100
  @update_max_threads 4

  @spec update_all_points() :: {table_size :: integer(), num_batches :: integer(), exec_time :: integer()}
  def update_all_points do
    start_time = DateTime.utc_now()
    Logger.info("Starting update at: #{start_time}")
    {num_batches, table_size} = count_number_of_batches()

    do_update(num_batches, table_size)
    end_time = DateTime.utc_now()
    exec_time = DateTime.diff(end_time, start_time, :second)
    Logger.info("Finishing update at: #{end_time}")

    log_execution_result(table_size, num_batches, exec_time)
    {table_size, num_batches, exec_time}
  end

  defp count_number_of_batches do
    table_size = Repo.aggregate(User, :count, :id)

    num_batches =
      (table_size / @batch_size)
      |> Float.ceil(0)
      |> trunc()

    {num_batches, table_size}
  end

  defp do_update(_, 0 = _table_size), do: :noop

  defp do_update(num_batches, _) do
    0..(num_batches - 1)
    |> Stream.chunk_every(@update_max_threads)
    |> Stream.map(fn batch_numbers ->
      Task.async_stream(
        batch_numbers,
        &update_batch/1,
        max_concurrency: @update_max_threads
      )
      |> Enum.to_list()
    end)
    |> Stream.run()
  end

  defp update_batch(batch_number) do
    batch_from_id = batch_number * @batch_size + 1
    batch_to_id = (batch_number + 1) * @batch_size

    Users.update_all_points_in_range_by_max_rand(batch_from_id, batch_to_id, @max_update_point)
  end

  defp log_execution_result(table_size, num_batches, exec_time) do
    log = """
    Total registries: #{table_size}\n\
    Number of batches: #{num_batches}\n\
    Total time: #{exec_time}s\
    """

    Logger.info(log)
  end
end
