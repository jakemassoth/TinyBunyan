defmodule TinyBunyanWeb.LogJSON do
  alias TinyBunyan.Logs.Log

  @doc """
  Renders a list of logs.
  """
  def index(%{logs: logs}) do
    %{data: for(log <- logs, do: data(log))}
  end

  @doc """
  Renders a single log.
  """
  def show(%{log: log}) do
    %{data: data(log)}
  end

  defp data(%Log{} = log) do
    %{
      id: log.id,
      content: log.content,
      fired_at: log.fired_at,
      uuid: log.uuid,
      project_id: log.project_id
    }
  end
end
