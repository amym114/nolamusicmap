defmodule Notjazzfest.Venues.Venue do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:wwoz_venue_id, :string, []}

  schema "venues" do
    field :unique_id, :integer
    field :name, :string
    field :description, :string
    field :state, :string
    field :zip, :string
    field :street_address, :string
    field :city, :string
    field :website, :string
    field :phone, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(venue, attrs) do
    venue
    |> cast(attrs, [
      :wwoz_venue_id,
      :name,
      :description,
      :street_address,
      :city,
      :state,
      :zip,
      :website,
      :phone,
      :email
    ])
    |> validate_required([
      :wwoz_venue_id,
      :name
    ])
  end
end
