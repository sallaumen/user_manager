defmodule UserManager.User.UpdaterTest do
  use UserManager.DataCase
  alias Ecto.UUID
  alias UserManager.Factories.UserFactory
  alias UserManager.Users
  alias UserManager.User.Updater

  describe "update_all_points/" do
    test "when user exists but min_point above user point, should not find any user" do
      user = UserFactory.insert(:user, points: 10)
      Updater.update_all_points()

      assert Users.fetch_user_by_id(min_point, _quantity = 1) == []
    end

    #    test "when user exists and min_point below user point, should return user in a list" do
    #      user = UserFactory.insert(:user, points: 10)
    #      min_point = 9
    #
    #      assert_users_returned_by_min_points([user], 1, Users.find_users_by_min_point(min_point, _quantity = 1))
    #    end
    #
    #    test "when user exists and min_point equals user point, should not find any user" do
    #      UserFactory.insert(:user, points: 10)
    #      min_point = 10
    #
    #      assert Users.find_users_by_min_point(min_point, _quantity = 1) == []
    #    end
    #
    #    test "when multiple users exist and multiple users are above min_point, should return users above min_point in the size limit requested" do
    #      user_1 = UserFactory.insert(:user, points: 10)
    #      user_2 = UserFactory.insert(:user, points: 20)
    #      user_3 = UserFactory.insert(:user, points: 30)
    #      user_4 = UserFactory.insert(:user, points: 40)
    #
    #      assert_users_returned_by_min_points([user_3], 1, Users.find_users_by_min_point(_min_point = 25, _quantity = 1))
    #
    #      assert_users_returned_by_min_points(
    #        [user_3, user_4],
    #        2,
    #        Users.find_users_by_min_point(_min_point = 25, _quantity = 2)
    #      )
    #
    #      assert_users_returned_by_min_points(
    #        [user_1, user_2, user_3],
    #        3,
    #        Users.find_users_by_min_point(_min_point = 5, _quantity = 3)
    #      )
    #
    #      assert_users_returned_by_min_points([user_4], 1, Users.find_users_by_min_point(_min_point = 35, _quantity = 20))
    #    end
  end

  defp assert_users_returned_by_min_points(expected_users, expected_user_count, response) do
    assert Enum.count(response) == expected_user_count

    response
    |> Enum.zip(expected_users)
    |> Enum.map(fn {response_line, expected_user} ->
      assert response_line.id == expected_user.id
      assert response_line.points == expected_user.points
    end)
  end
end
