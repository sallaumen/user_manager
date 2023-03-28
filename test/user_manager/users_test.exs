defmodule UserManager.UsersTest do
  use UserManager.DataCase
  alias UserManager.Factories.UserFactory
  alias UserManager.Users

  describe "fetch_user_by_id/1" do
    test "when user exists, should return {:ok, user} tuple" do
      user = UserFactory.insert(:user)

      assert Users.fetch_user_by_id(user.id) == {:ok, user}
    end

    test "when user does not exist, should return {:error, detail} tuple" do
      fake_id = 1

      assert Users.fetch_user_by_id(fake_id) == {:error, "User not found given for ID `#{fake_id}`"}
    end
  end

  describe "find_users_by_min_point/2" do
    test "when user exists but min_point above user point, should not find any user" do
      UserFactory.insert(:user, points: 10)
      min_point = 11

      assert Users.find_users_by_min_point(min_point, _quantity = 1) == []
    end

    test "when user exists and min_point below user point, should return user in a list" do
      user = UserFactory.insert(:user, points: 10)
      min_point = 9

      assert_users_returned_by_min_points([user], 1, Users.find_users_by_min_point(min_point, _quantity = 1))
    end

    test "when user exists and min_point equals user point, should not find any user" do
      UserFactory.insert(:user, points: 10)
      min_point = 10

      assert Users.find_users_by_min_point(min_point, _quantity = 1) == []
    end

    test "when multiple users exist and multiple users are above min_point, should return users above min_point in the size limit requested" do
      user_1 = UserFactory.insert(:user, points: 10)
      user_2 = UserFactory.insert(:user, points: 20)
      user_3 = UserFactory.insert(:user, points: 30)
      user_4 = UserFactory.insert(:user, points: 40)

      assert_users_returned_by_min_points([user_3], 1, Users.find_users_by_min_point(_min_point = 25, _quantity = 1))

      assert_users_returned_by_min_points(
        [user_3, user_4],
        2,
        Users.find_users_by_min_point(_min_point = 25, _quantity = 2)
      )

      assert_users_returned_by_min_points(
        [user_1, user_2, user_3],
        3,
        Users.find_users_by_min_point(_min_point = 5, _quantity = 3)
      )

      assert_users_returned_by_min_points([user_4], 1, Users.find_users_by_min_point(_min_point = 35, _quantity = 20))
    end
  end

  describe "create_user/1" do
    test "when user does not exist, should return {:ok, user} tuple" do
      {:ok, user} = Users.create_user(%{points: 10})

      assert Users.fetch_user_by_id(user.id) == {:ok, user}
    end
  end

  describe "update_user/1" do
    test "when user exists, should return {:ok, updated_user} tuple" do
      user = UserFactory.insert(:user, points: 5)

      Users.update_user(user, %{points: 10})
      {:ok, updated_user} = Users.fetch_user_by_id(user.id)
      assert %{points: 10} = updated_user
    end

    test "when user does not exist, should return {:error, detail} tuple" do
      fake_id = 9999
      fake_user = UserFactory.build(:user, id: fake_id, points: 5)

      assert {:error, _} = Users.update_user(fake_user, %{points: 10})
    end
  end

  describe "update_all_points_in_range_by_max_rand/3" do
    test "when user in range, should update user points and updated_at" do
      user = UserFactory.insert(:user, updated_at: ~N|2022-01-01 00:00:00|)

      assert {1, [new_points]} = Users.update_all_points_in_range_by_max_rand(user.id, user.id, 999_999)
      {:ok, updated_user} = Users.fetch_user_by_id(user.id)

      refute updated_user.updated_at == user.updated_at
      assert updated_user.points == new_points
    end

    test "when user not in range, should not update user points and updated_at" do
      user = UserFactory.insert(:user, updated_at: ~N|2022-01-01 00:00:00|)
      from_id = user.id + 1
      to_id = user.id + 100

      assert {0, []} == Users.update_all_points_in_range_by_max_rand(from_id, to_id, 999_999)
      {:ok, not_updated_user} = Users.fetch_user_by_id(user.id)

      assert not_updated_user.updated_at == user.updated_at
    end

    test "when more than one user in range, should update users points and updated_ats" do
      user_1 = UserFactory.insert(:user, updated_at: ~N|2022-01-01 00:00:00|)
      user_2 = UserFactory.insert(:user, updated_at: ~N|2022-01-01 00:00:00|)
      user_3 = UserFactory.insert(:user, updated_at: ~N|2022-01-01 00:00:00|)

      assert {2, _} = Users.update_all_points_in_range_by_max_rand(user_2.id, user_3.id, 100)

      {:ok, not_updated_user_1} = Users.fetch_user_by_id(user_1.id)
      {:ok, updated_user_2} = Users.fetch_user_by_id(user_2.id)
      {:ok, updated_user_3} = Users.fetch_user_by_id(user_3.id)

      assert not_updated_user_1.updated_at == user_1.updated_at
      assert updated_user_2.updated_at != user_2.updated_at
      assert updated_user_3.updated_at != user_3.updated_at
    end
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
