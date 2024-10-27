defmodule TinyBunyanWeb.FilterController do
  use TinyBunyanWeb, :controller

  alias TinyBunyan.Filters
  alias TinyBunyan.Filters.Filter

  action_fallback(TinyBunyanWeb.FallbackController)

  def index(conn, %{"project_id" => project_id}) do
    filters = Filters.list_filters(project_id)
    render(conn, :index, filters: filters, project_id: project_id)
  end

  def new(conn, %{"project_id" => project_id}) do
    changeset = Filters.change_filter(%Filter{})
    render(conn, :new, changeset: changeset, project_id: project_id)
  end

  def create(conn, %{"filter" => filter_params, "project_id" => project_id}) do
    filter_with_project_id = Map.put(filter_params, "project_id", project_id)

    case Filters.create_filter(filter_with_project_id) do
      {:ok, filter} ->
        conn
        |> put_flash(:info, "Filter created successfully.")
        |> redirect(to: ~p"/projects/#{project_id}/filters/#{filter}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, project_id: project_id)
    end
  end

  def show(conn, %{"id" => id, "project_id" => project_id}) do
    filter = Filters.get_filter!(id, project_id)
    render(conn, :show, filter: filter)
  end

  def edit(conn, %{"id" => id, "project_id" => project_id}) do
    filter = Filters.get_filter!(id, project_id)
    changeset = Filters.change_filter(filter)
    render(conn, :edit, filter: filter, changeset: changeset)
  end

  def update(conn, %{"project_id" => project_id, "id" => id, "filter" => filter_params}) do
    filter = Filters.get_filter!(id, project_id)

    case Filters.update_filter(filter, filter_params) do
      {:ok, filter} ->
        conn
        |> put_flash(:info, "Filter updated successfully.")
        |> redirect(to: ~p"/projects/#{project_id}/filters/#{filter}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, filter: filter, changeset: changeset)
    end
  end

  def delete(conn, %{"project_id" => project_id, "id" => id}) do
    filter = Filters.get_filter!(id, project_id)
    {:ok, _filter} = Filters.delete_filter(filter)

    conn
    |> put_flash(:info, "Filter deleted successfully.")
    |> redirect(to: ~p"/projects/#{project_id}/filters")
  end
end
