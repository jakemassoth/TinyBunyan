defmodule TinyBunyan.Repo.Migrations.RemoveIngestAtColumn do
  use Ecto.Migration

  def change do
    alter table(:logs) do
      remove(:ingested_at)
    end
  end
end
