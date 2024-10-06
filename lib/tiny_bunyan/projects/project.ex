defmodule TinyBunyan.Projects.Project do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :project_id}
  @primary_key {:project_id, :id, autogenerate: true}
  schema "projects" do
    field :name, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
