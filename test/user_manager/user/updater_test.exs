defmodule UserManager.User.UpdaterTest do
  use UserManager.DataCase
  alias UserManager.Factories.UserFactory
  alias UserManager.Repo
  alias UserManager.User
  alias UserManager.User.Updater

  describe "update_all_points/0" do
    test "when user exists, should increase 0 or more for every user" do
      user_1 = UserFactory.insert(:user, points: 0)
      user_2 = UserFactory.insert(:user, points: 0)
      user_3 = UserFactory.insert(:user, points: 0)
      assert {_table_size = 3, _, _} = Updater.update_all_points()

      user_1 = Repo.get(User, user_1.id)
      user_2 = Repo.get(User, user_2.id)
      user_3 = Repo.get(User, user_3.id)

      assert user_1.points != 0 || user_2.points != 0 || user_3.points != 0
    end

    test "when no user exists, should not update anything" do
      assert {_table_size = 0, _, _} = Updater.update_all_points()
    end
  end
end
