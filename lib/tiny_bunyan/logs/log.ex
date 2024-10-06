defmodule TinyBunyan.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :content, :map
    field :fired_at, :utc_datetime
    field :uuid, Ecto.UUID, autogenerate: true
    field :project_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:content, :uuid, :fired_at, :content, :project_id])
    |> validate_required([:content, :fired_at, :project_id])
  end
end
