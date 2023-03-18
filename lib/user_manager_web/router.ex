defmodule UserManagerWeb.Router do
  use UserManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UserManagerWeb do
    pipe_through :api
    get("/", UsersController, :list)
  end
end
