defmodule UserManager.User.PointsUpdaterTest do
  use UserManager.DataCase
  alias UserManager.Factories.UserFactory
  alias UserManager.Repo
  alias UserManager.User
  alias UserManager.User.PointsUpdater

  describe "update_all_points/0" do
    test "when user exists, should increase 0 or more for every user" do
      user_1 = UserFactory.insert(:user, points: 0)
      user_2 = UserFactory.insert(:user, points: 0)
      user_3 = UserFactory.insert(:user, points: 0)
      :timer.sleep(1_000)
      assert {_table_size = 3, _, _} = PointsUpdater.update_all_points()

      user_1_new = Repo.get(User, user_1.id)
      user_2_new = Repo.get(User, user_2.id)
      user_3_new = Repo.get(User, user_3.id)

      assert user_1_new.points != 0 || user_2_new.points != 0 || user_3_new.points != 0
      assert user_1.updated_at != user_1_new.updated_at
      assert user_2.updated_at != user_2_new.updated_at
      assert user_3.updated_at != user_3_new.updated_at
    end

    test "when no user exists, should not update anything" do
      assert {_table_size = 0, _, _} = PointsUpdater.update_all_points()
    end
  end
end
