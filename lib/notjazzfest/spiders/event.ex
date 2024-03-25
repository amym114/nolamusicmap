defmodule Notjazzfest.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :title, :string
    field :date, :utc_datetime
    field :wwoz_venue_id, :string
    field :description, :string
    field :wwoz_id, :integer
    timestamps()
  end

    @doc false
    def changeset(target, attrs) do
      target
      |> cast(attrs, [:title, :date, :venue, :description])
      |> validate_required([:title, :date, :wwoz_venue_id])
    end

end
