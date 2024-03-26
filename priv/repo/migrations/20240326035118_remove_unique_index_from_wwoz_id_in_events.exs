defmodule Notjazzfest.Repo.Migrations.RemoveUniqueIndexFromWwozIdInEvents do
  use Ecto.Migration

  def change do
    drop index(:events, [:wwoz_id], name: :unique_wwoz_id)
  end
end
