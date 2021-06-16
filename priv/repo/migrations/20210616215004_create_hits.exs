defmodule Bagheera.Repo.Migrations.CreateHits do
  use Ecto.Migration

  alias Bagheera.Links.Hit

  def change do
    create table(:hits) do
      add :link_id, references(:links, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
