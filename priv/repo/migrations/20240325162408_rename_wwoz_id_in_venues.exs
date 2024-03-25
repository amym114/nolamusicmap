defmodule Notjazzfest.Repo.Migrations.RenameWwozIdInVenues do
  use Ecto.Migration

  def change do
    rename table(:venues), :wwoz_id, to: :wwoz_venue_id
  end
end
