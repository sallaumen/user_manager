# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     UserManager.Repo.insert!(%UserManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
require Logger
alias UserManager.Repo
alias UserManager.Factories.UserFactory
alias UserManager.User
# Fill User table with 1 million entries
current_table_size = Repo.aggregate(User, :count, :id)

expected_db_size = 1_000_000

insert_count = expected_db_size - current_table_size
Logger.info("Inserting `#{insert_count}` entries to table `users`")

if insert_count > 0 do
  insert_batch_size = 500
  total_batches = trunc(insert_count / insert_batch_size)

  Enum.map(0..total_batches, fn batch ->
    Logger.info("Inserting user batch `#{batch}/#{total_batches}`. Percentage `#{batch / total_batches * 100}%`")
    UserFactory.insert_list(insert_batch_size, :user)
  end)
end
