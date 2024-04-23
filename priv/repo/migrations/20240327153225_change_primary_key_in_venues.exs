defmodule Notjazzfest.Repo.Migrations.ChangePrimaryKeyInVenues do
  use Ecto.Migration

  def change do
    drop_if_exists table(:venues)

    create table(:venues, primary_key: false) do
      add :wwoz_venue_id, :string, size: 255, primary_key: true
      add :unique_id, :bigserial
      add :name, :string, size: 255
      add :description, :string
      add :street_address, :string, size: 255
      add :city, :string, size: 255
      add :state, :string, size: 255
      add :zip, :string, size: 255
      add :website, :string, size: 255
      add :phone, :string, size: 255
      add :email, :string, size: 255

      timestamps(type: :utc_datetime)
    end

    create unique_index(:venues, [:wwoz_venue_id])
  end
end
