defmodule Bagheera.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def change do
    create table(:visits) do
      add :link_id, references(:links, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
