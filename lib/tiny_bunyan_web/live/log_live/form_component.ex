defmodule TinyBunyanWeb.LogLive.FormComponent do
  use TinyBunyanWeb, :live_component

  alias TinyBunyan.Logs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage log records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="log-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="text" label="Content" />
        <.input field={@form[:uuid]} type="text" label="Uuid" />
        <.input field={@form[:ingested_at]} type="datetime-local" label="Ingested at" />
        <.input field={@form[:fired_at]} type="datetime-local" label="Fired at" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Log</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{log: log} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Logs.change_log(log))
     end)}
  end

  @impl true
  def handle_event("validate", %{"log" => log_params}, socket) do
    changeset = Logs.change_log(socket.assigns.log, log_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"log" => log_params}, socket) do
    save_log(socket, socket.assigns.action, log_params)
  end

  defp save_log(socket, :edit, log_params) do
    case Logs.update_log(socket.assigns.log, log_params) do
      {:ok, log} ->
        notify_parent({:saved, log})

        {:noreply,
         socket
         |> put_flash(:info, "Log updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_log(socket, :new, log_params) do
    case Logs.create_log(log_params) do
      {:ok, log} ->
        notify_parent({:saved, log})

        {:noreply,
         socket
         |> put_flash(:info, "Log created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
