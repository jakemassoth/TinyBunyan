defmodule TinyBunyan.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :content, :map
    field :fired_at, :utc_datetime
    field :uuid, Ecto.UUID, autogenerate: true

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:content, :uuid, :fired_at, :content])
    |> validate_required([:content, :fired_at])
  end
end
