defmodule Notjazzfest.Venues do
  @moduledoc """
  The Venues context.
  """

  import Ecto.Query, warn: false
  alias Notjazzfest.Repo

  alias Notjazzfest.Venues.Venue

  @doc """
  Returns the list of venues.

  ## Examples

      iex> list_venues()
      [%Venue{}, ...]

  """
  def list_venues do
    Repo.all(Venue)
  end

  @doc """
  Gets a single venue.

  Raises `Ecto.NoResultsError` if the Venue does not exist.

  ## Examples

      iex> get_venue!(123)
      %Venue{}

      iex> get_venue!(456)
      ** (Ecto.NoResultsError)

  """
  def get_venue!(unique_id), do: Repo.get!(Venue, unique_id)

  @doc """
  Creates a venue.

  ## Examples

      iex> create_venue(%{field: value})
      {:ok, %Venue{}}

      iex> create_venue(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_venue(attrs \\ %{}) do
    %Venue{}
    |> Venue.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a venue.

  ## Examples

      iex> update_venue(venue, %{field: new_value})
      {:ok, %Venue{}}

      iex> update_venue(venue, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_venue(%Venue{} = venue, attrs) do
    venue
    |> Venue.changeset(attrs)
    |> Repo.update()
  end

  # @doc """
  # Inserts or Updates a venue.

  # ## Examples

  #     iex> insert_or_update_venue(venue, %{field: new_value})
  #     {:ok, %Event{}}

  #     iex> insert_or_update_venue(venue, %{field: bad_value})
  #     {:error, %Ecto.Changeset{}}

  # """
  def insert_or_update_venue(%Venue{} = venue, attrs) do
    case Repo.get(Venue, attrs.wwoz_venue_id) do
      # Venue not found, we build one
      nil ->
        %Venue{
          lat: geocode_location(attrs).lat,
          long: geocode_location(attrs).lon,
          wwoz_venue_id: attrs.wwoz_venue_id
        }

      # Venue exists, let's use it
      venue ->
        venue
    end
    |> Venue.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @doc """
  Deletes a venue.

  ## Examples

      iex> delete_venue(venue)
      {:ok, %Venue{}}

      iex> delete_venue(venue)
      {:error, %Ecto.Changeset{}}

  """
  def delete_venue(%Venue{} = venue) do
    Repo.delete(venue)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking venue changes.

  ## Examples

      iex> change_venue(venue)
      %Ecto.Changeset{data: %Venue{}}

  """
  def change_venue(%Venue{} = venue, attrs \\ %{}) do
    Venue.changeset(venue, attrs)
  end

  def geocode_location(attrs) do
    {:ok, coordinates} =
      Geocoder.call(
        attrs.street_address <>
          ", " <> attrs.city <> ", " <> attrs.state
      )

    coordinates
  end
end
