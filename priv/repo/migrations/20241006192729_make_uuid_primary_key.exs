defmodule TinyBunyan.Repo.Migrations.MakeUuidPrimaryKey do
  use Ecto.Migration

  def change do
    alter table(:logs) do
      modify :uuid, :uuid, primary_key: true, null: false
      remove :id
    end

  end
end
