defmodule UserManagerWeb.UsersController do
  use UserManagerWeb, :controller
  require Logger
  alias UserManager.User.FetcherAgent
  alias UserManagerWeb.Controllers.Schemas.Users, as: UsersSchema
  alias UserManagerWeb.Utils.ErrorMessages
  alias UserManagerWeb.Utils.ParamsConverter
  action_fallback UserManagerWeb.FallbackController

  @list_users_api_default_limit 2

  def list(conn, params) do
    with %{valid?: true} <- UsersSchema.changeset(params),
         {:ok, min_number} <-
           ParamsConverter.try_converting_to_integer(params["min_number"], "min_number"),
         %{last_call: last_call_datetime, users: users} <-
           FetcherAgent.get_users_by_min_points(min_number, @list_users_api_default_limit) do
      render(conn, :list, %{users: users, last_call_datetime: last_call_datetime})
    else
      {:error, message} ->
        {:error, %{message: message}}

      %{valid?: false, errors: [min_number: {"can't be blank", _}]} ->
        {:error, %{message: ErrorMessages.get_required_field_err_message("min_number")}}

      %{valid?: false, errors: [min_number: {"is invalid", _}]} ->
        {:error,
         %{
           message:
             ErrorMessages.get_invalid_type_err_message(params["min_number"], "min_number", "integer or string integer")
         }}

      err ->
        {:error, err}
    end
  end
end
