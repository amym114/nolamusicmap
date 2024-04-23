defmodule Notjazzfest.VenuesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Notjazzfest.Venues` context.
  """

  @doc """
  Generate a venue.
  """
  def venue_fixture(attrs \\ %{}) do
    {:ok, venue} =
      attrs
      |> Enum.into(%{
        city: "some city",
        description: "some description",
        email: "some email",
        name: "some name",
        phone: "some phone",
        state: "some state",
        street_address: "some street_address",
        website: "some website",
        wwoz_id: "some wwoz_id",
        zip: "some zip"
      })
      |> Notjazzfest.Venues.create_venue()

    venue
  end
end
