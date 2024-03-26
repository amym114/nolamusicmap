defmodule Notjazzfest.Repo.Migrations.AddUniqueIndexToWwozIdInEvents do
  use Ecto.Migration

  def change do
    create unique_index(:events, [:wwoz_id], name: :unique_wwoz_id)
  end
end
