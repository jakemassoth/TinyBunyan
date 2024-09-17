defmodule TinyBunyanWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TinyBunyanWeb, :controller

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: TinyBunyanWeb.ErrorHTML, json: TinyBunyanWeb.ErrorJSON)
    |> render(:"404")
  end  

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: TinyBunyanWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end
end
