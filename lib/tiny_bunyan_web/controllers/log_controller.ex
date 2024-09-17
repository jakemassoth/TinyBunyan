defmodule TinyBunyanWeb.LogController do
  use TinyBunyanWeb, :controller

  alias TinyBunyan.Logs
  alias TinyBunyan.Logs.Log

  action_fallback TinyBunyanWeb.FallbackController

  def index(conn, _params) do
    logs = Logs.list_logs()
    render(conn, :index, logs: logs)
  end

  def create(conn, %{"log" => log_params}) do
    with {:ok, %Log{} = log} <- Logs.create_log(log_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/logs/#{log}")
      |> render(:show, log: log)
    end
  end

  def show(conn, %{"id" => id}) do
    log = Logs.get_log!(id)
    render(conn, :show, log: log)
  end

  def update(conn, %{"id" => id, "log" => log_params}) do
    log = Logs.get_log!(id)

    with {:ok, %Log{} = log} <- Logs.update_log(log, log_params) do
      render(conn, :show, log: log)
    end
  end

  def delete(conn, %{"id" => id}) do
    log = Logs.get_log!(id)

    with {:ok, %Log{}} <- Logs.delete_log(log) do
      send_resp(conn, :no_content, "")
    end
  end
end
