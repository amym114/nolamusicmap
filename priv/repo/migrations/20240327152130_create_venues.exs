defmodule Notjazzfest.Repo.Migrations.CreateVenues do
  use Ecto.Migration

  def change do
    drop_if_exists table(:venues)

    create table(:venues) do
      add :wwoz_id, :string, size: 255
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
  end
end
