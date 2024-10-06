defmodule TinyBunyanWeb.LogLive.Index do
  use TinyBunyanWeb, :live_view

  alias TinyBunyan.Logs

  @impl true
  def mount(%{"project_id" => project_id}, _session, socket) do
    if connected?(socket), do: Logs.subscribe(project_id)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"project_id" => project_id}, _uri, socket) do
    {
      :noreply, 
      socket
      |> assign(:project_id, project_id)
      |> assign(:page_title, page_title(project_id))
      |> fetch()
    }
  end

  defp fetch(socket) do
    logs = Logs.list_logs(socket.assigns.project_id)
    socket |> assign(:logs, logs)
  end

  @impl true
  def handle_info({TinyBunyan.Logs, :created, _}, socket) do
    IO.puts("got new log")
    {:noreply, fetch(socket)}
  end

  defp page_title(project_id), do: "Logs for project #{project_id}"
end
