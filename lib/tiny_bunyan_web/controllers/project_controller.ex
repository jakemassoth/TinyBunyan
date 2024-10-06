defmodule TinyBunyanWeb.ProjectController do
  use TinyBunyanWeb, :controller

  alias TinyBunyan.Projects
  alias TinyBunyan.Projects.Project

  def index(conn, _params) do
    projects = Projects.list_projects()
    render(conn, :index, projects: projects)
  end

  def new(conn, _params) do
    changeset = Projects.change_project(%Project{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"project" => project_params}) do
    case Projects.create_project(project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project created successfully.")
        |> redirect(to: ~p"/projects/#{project}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => project_id}) do
    project = Projects.get_project!(project_id)
    render(conn, :show, project: project)
  end

  def edit(conn, %{"id" => project_id}) do
    project = Projects.get_project!(project_id)
    changeset = Projects.change_project(project)
    render(conn, :edit, project: project, changeset: changeset)
  end

  def update(conn, %{"id" => project_id, "project" => project_params}) do
    project = Projects.get_project!(project_id)

    case Projects.update_project(project, project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "Project updated successfully.")
        |> redirect(to: ~p"/projects/#{project}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, project: project, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => project_id}) do
    project = Projects.get_project!(project_id)
    {:ok, _project} = Projects.delete_project(project)

    conn
    |> put_flash(:info, "Project deleted successfully.")
    |> redirect(to: ~p"/projects")
  end
end
