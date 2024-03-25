defmodule Notjazzfest.Repo.Migrations.RenameVenueInEvents do
  use Ecto.Migration

  def change do
    rename table(:events), :venue, to: :wwoz_venue_id
  end
end
