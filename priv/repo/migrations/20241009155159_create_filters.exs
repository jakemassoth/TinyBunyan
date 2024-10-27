defmodule TinyBunyan.Repo.Migrations.CreateFilters do
  use Ecto.Migration

  def change do
    create table(:filters) do
      add :uuid, :uuid, primary_key: true
      add :query, :string
      add :project_id, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
