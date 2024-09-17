defmodule TinyBunyanWeb.LogLive.Index do
  use TinyBunyanWeb, :live_view

  alias TinyBunyan.Logs

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Logs.subscribe()
    {:ok, fetch(socket)}
  end

  defp fetch(socket) do
    logs = Logs.list_logs()
    assign(socket, logs: logs)
  end

  @impl true
  def handle_info({TinyBunyan.Logs, :created, _}, socket) do
    IO.puts("got new log")
    {:noreply, fetch(socket)}
  end
end
