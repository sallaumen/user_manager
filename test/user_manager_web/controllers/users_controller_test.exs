defmodule UserManagerWeb.UsersControllerTest do
  use UserManagerWeb.ConnCase, async: true

  alias UserManager.Factories.UserFactory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list/2" do
    test "when exists 1 user over min_points, should return reduced user data in list", %{conn: conn} do
      user = UserFactory.insert(:user, points: 11)

      conn = get(conn, "/", min_number: 10)
      assert [%{"id" => user.id, "points" => 11}] == json_response(conn, 200)
    end

    test "when more than 2 user over min_points exist, should return 2 reduced user data in list", %{conn: conn} do
      user1 = UserFactory.insert(:user, points: 11)
      user2 = UserFactory.insert(:user, points: 12)
      _user3 = UserFactory.insert(:user, points: 13)

      conn = get(conn, "/", min_number: 10)
      assert [%{"id" => user1.id, "points" => 11}, %{"id" => user2.id, "points" => 12}] == json_response(conn, 200)
    end

    test "when no user found with points over min_number, should return empty list", %{conn: conn} do
      UserFactory.insert(:user, points: 9)
      UserFactory.insert(:user, points: 10)

      conn = get(conn, "/", min_number: 10)
      assert [] == json_response(conn, 200)
    end

    test "when min_number is not a numeric value, should return error", %{conn: conn} do
      conn = get(conn, "/", min_number: "test")

      assert %{
               "error" =>
                 "Invalid parameter. Given value `test` for parameter `min_number` is not a valid integer or string integer."
             } == json_response(conn, 400)
    end

    test "when min_number is nil, should return error", %{conn: conn} do
      conn = get(conn, "/", min_number: nil)

      assert %{
               "error" =>
                 "Invalid parameter. Given value `` for parameter `min_number` is not a valid integer or string integer."
             } == json_response(conn, 400)
    end
  end
end
