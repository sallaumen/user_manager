defmodule UserManagerWeb.FallbackController do
  use UserManagerWeb, :controller
  require Logger
  alias UserManagerWeb.Views.ChangesetJSON
  alias UserManagerWeb.Views.ErrorView

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  def call(conn, {:error, params = %{message: message}}) do
    status_code = Map.get(params, :status_code, resolve_error_status_code(message))
    Logger.error("Error fallback: #{inspect(message)}, Status: #{status_code}")

    conn
    |> put_status(status_code)
    |> put_view(ErrorView)
    |> render("error.json", %{error: message})
  end

  def call(conn, err) do
    Logger.error("Critical error fallback (Internal Server error): Err: `#{inspect(err)}, Conn`#{inspect(conn)}")

    conn
    |> put_status(:internal_server_error)
    |> put_view(ErrorJSON)
    |> render("error.json", %{error: "Internal Server Error."})
  end

  defp resolve_error_status_code(error_message) do
    cond do
      String.contains?(error_message, "not found") -> :not_found
      String.contains?(error_message, "Invalid parameter") -> :bad_request
      true -> :internal_server_error
    end
  end
end
