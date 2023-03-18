defmodule UserManagerWeb.ErrorViewTest do
  use UserManagerWeb.ConnCase, async: true

  alias UserManagerWeb.Views.ErrorView

  describe "render/2" do
    test "when valid format given, should return error map" do
      assert ErrorView.render("error.json", %{error: "test"}) == %{error: "test"}
    end

    test "when default format given, should return error considering given format" do
      assert ErrorView.render("404.json", %{error: "test"}) == %{errors: %{detail: "Not Found"}}
      assert ErrorView.render("500.json", %{error: "test"}) == %{errors: %{detail: "Internal Server Error"}}
    end
  end
end
