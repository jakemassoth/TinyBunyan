defmodule TinyBunyan.Filters.Filter do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :uuid}
  @primary_key {:uuid, Ecto.UUID, autogenerate: true}
  schema "filters" do
    field(:query, :string)
    field(:project_id, :integer)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(filter, attrs) do
    filter
    |> cast(attrs, [:query, :project_id])
    |> validate_required([:query, :project_id])
  end
end
