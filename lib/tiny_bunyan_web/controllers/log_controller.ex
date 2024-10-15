defmodule TinyBunyanWeb.LogController do
  use TinyBunyanWeb, :controller

  alias TinyBunyan.Logs
  alias TinyBunyan.Logs.Log

  action_fallback(TinyBunyanWeb.FallbackController)

  def index(conn, %{"project_id" => project_id}) do
    logs = Logs.list_logs(project_id)
    render(conn, :index, logs: logs)
  end

  def create(conn, %{"log" => log_params}) do
    with {:ok, %Log{} = log} <- Logs.create_log(log_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/v1/projects/#{log.project_id}/logs/#{log}")
      |> render(:show, log: log)
    end
  end

  def show(conn, %{"id" => id, "project_id" => project_id}) do
    log = Logs.get_log!(id, project_id)
    render(conn, :show, log: log)
  end
end
