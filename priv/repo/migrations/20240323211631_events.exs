defmodule Notjazzfest.Repo.Migrations.Events do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :title, :string
      add :date, :utc_datetime
      add :venue, :string
      add :description, :text
      timestamps()
    end
  end
end
