defmodule Notjazzfest.Repo.Migrations.ConvertWwozIdToString do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :wwoz_id, :string
    end
  end
end
