defmodule TinyBunyan.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :uuid}
  @primary_key {:uuid, Ecto.UUID, autogenerate: false}
  schema "logs" do
    field(:content, :map)
    field(:fired_at, :utc_datetime)
    field(:project_id, :integer)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:content, :fired_at, :content, :project_id])
    |> gen_uuid()
    |> validate_required([:content, :fired_at, :project_id])
  end

  defp gen_uuid(changeset) do
    put_change(changeset, :uuid, Ecto.UUID.generate())
  end
end
