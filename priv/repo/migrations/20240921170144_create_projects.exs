defmodule TinyBunyan.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects, primary_key: false) do
      add :name, :string
      add :project_id, :bigserial, primary_key: true

      timestamps(type: :utc_datetime)
    end
  end
end
