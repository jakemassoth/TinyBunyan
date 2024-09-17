defmodule TinyBunyan.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :uuid, :uuid
      add :ingested_at, :utc_datetime
      add :fired_at, :utc_datetime
      add :content, :map

      timestamps(type: :utc_datetime)
    end
  end
  def down do
    drop table(:logs)
  end
end
