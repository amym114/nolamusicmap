defmodule Notjazzfest.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:wwoz_id, :string, []}

  schema "events" do
    field :unique_id, :integer
    field :title, :string
    field :date, :string
    field :description, :string
    field :wwoz_venue_id, :string

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:unique_id, :wwoz_id, :title, :date, :description, :wwoz_venue_id])
    |> validate_required([:wwoz_id, :title, :date, :wwoz_venue_id])
    |> unique_constraint(:wwoz_id)
  end
end
