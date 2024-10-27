defmodule TinyBunyan.Repo.Migrations.LinkUserToProject do
  use Ecto.Migration

  def change do
    create table(:user_projects, primary_key: false) do
      add :user_id, references(:users)
      add :project_id, :integer
    end

    create index(:user_projects, [:user_id])
    create unique_index(:user_projects, [:user_id, :project_id])

  end
end
