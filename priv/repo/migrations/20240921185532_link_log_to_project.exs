defmodule TinyBunyan.Repo.Migrations.LinkLogToProject do
  use Ecto.Migration

  def change do
    alter table(:logs) do
      add :project_id, :integer, null: false
    end
    create unique_index(:logs, [:id, :project_id])
  end
end
