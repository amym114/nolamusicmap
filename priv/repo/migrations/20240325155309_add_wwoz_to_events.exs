defmodule Notjazzfest.Repo.Migrations.AddWwozToEvents do
  use Ecto.Migration

  def change do
    alter table(:events) do
      add :wwoz_id, :integer
    end
  end
end
