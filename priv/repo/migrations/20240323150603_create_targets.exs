defmodule Notjazzfest.Repo.Migrations.CreateTargets do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :name, :string
      add :lat, :float
      add :lng, :float

      timestamps(type: :utc_datetime)
    end
  end
end
