defmodule Notjazzfest.Repo.Migrations.AlterEventsDateType do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :date, :string
    end
  end
end
