defmodule NotJazzfest.Repo.Migrations.CreateVenues do
  use Ecto.Migration

  def change do
    create table(:venues) do
      add :wwoz_id, :string, size: 255
      add :name, :string, size: 255
      add :description, :text
      add :street_address, :text
      add :city, :string, size: 255
      add :state, :string, size: 255
      add :zip, :string, size: 255

      timestamps()
    end
  end
end
