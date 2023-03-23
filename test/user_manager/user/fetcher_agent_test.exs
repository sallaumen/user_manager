defmodule UserManager.User.FetcherAgentTest do
  use UserManager.DataCase, async: false
  alias UserManager.Factories.UserFactory
  alias UserManager.User
  alias UserManager.User.FetcherAgent
  import ExUnit.CaptureLog

  describe "start_link/1" do
    test "when link not started, should start and return pid" do
      assert {:ok, _pid} = FetcherAgent.start_link([])
    end

    test "when link already started, should return error and log" do
      FetcherAgent.start_link([])
      log = capture_log(fn -> assert {:error, {:already_started, _pid}} = FetcherAgent.start_link([]) end)

      assert String.contains?(
               log,
               "[error] Failed stating `Elixir.UserManager.User.FetcherAgent` Genserver. Error: {:already_started"
             )
    end
  end

  describe "get_users_by_min_points/2" do
    setup do
      start_supervised(FetcherAgent)

      :ok
    end

    test "when user exists but min_point above user point, should not find any user" do
      UserFactory.insert(:user, points: 10)
      min_point = 11

      assert FetcherAgent.get_users_by_min_points(min_point, _quantity = 1) == %{last_call: nil, users: []}
    end

    test "when user exists and min_point below user point, should return user in a list" do
      user = UserFactory.insert(:user, points: 10)
      min_point = 9
      user_id = user.id

      assert %{last_call: nil, users: [%User{id: ^user_id, points: 10}]} =
               FetcherAgent.get_users_by_min_points(min_point, _quantity = 1)
    end

    test "when user exists and min_point equals user point, should not find any user" do
      UserFactory.insert(:user, points: 10)
      min_point = 10

      assert FetcherAgent.get_users_by_min_points(min_point, _quantity = 1) == %{last_call: nil, users: []}
    end

    test "when function called more than once, should also return the datetime of the last call" do
      quantity = 1
      min_point = 1

      %{last_call: last_call_1, users: []} = FetcherAgent.get_users_by_min_points(min_point, quantity)
      assert is_nil(last_call_1)

      :timer.sleep(1_000)

      %{last_call: last_call_2, users: []} = FetcherAgent.get_users_by_min_points(min_point, quantity)
      assert {:ok, _} = NaiveDateTime.from_iso8601(last_call_2)

      %{last_call: last_call_3, users: []} = FetcherAgent.get_users_by_min_points(min_point, quantity)
      assert {:ok, _} = NaiveDateTime.from_iso8601(last_call_3)
      assert last_call_2 != last_call_3
    end

    test "when multiple users exist and multiple users are above min_point, should return users above min_point in the size limit requested" do
      UserFactory.insert(:user, points: 10)
      UserFactory.insert(:user, points: 20)

      assert %{last_call: _, users: [%User{points: 10}]} = FetcherAgent.get_users_by_min_points(5, _quantity = 1)

      assert %{last_call: _, users: [%User{points: 10}, %User{points: 20}]} =
               FetcherAgent.get_users_by_min_points(5, _quantity = 2)
    end
  end
end
