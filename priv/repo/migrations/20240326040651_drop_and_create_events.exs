defmodule Notjazzfest.Repo.Migrations.DropAndCreateEvents do
  use Ecto.Migration

  def change do
    drop_if_exists table(:events)

    create table(:events, primary_key: false) do
      add :wwoz_id, :string, size: 255, primary_key: true
      add :title, :string, size: 255
      add :date, :string, size: 255
      add :description, :text
      add :wwoz_venue_id, :string, size: 255

      timestamps()
    end

    create unique_index(:events, [:wwoz_id])
  end
end
