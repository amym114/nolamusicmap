defmodule Notjazzfest.VenuesTest do
  use Notjazzfest.DataCase

  alias Notjazzfest.Venues

  describe "venues" do
    alias Notjazzfest.Venues.Venue

    import Notjazzfest.VenuesFixtures

    @invalid_attrs %{
      name: nil,
      state: nil,
      zip: nil,
      description: nil,
      wwoz_id: nil,
      street_address: nil,
      city: nil,
      website: nil,
      phone: nil,
      email: nil
    }

    test "list_venues/0 returns all venues" do
      venue = venue_fixture()
      assert Venues.list_venues() == [venue]
    end

    test "get_venue!/1 returns the venue with given id" do
      venue = venue_fixture()
      assert Venues.get_venue!(venue.id) == venue
    end

    test "create_venue/1 with valid data creates a venue" do
      valid_attrs = %{
        name: "some name",
        state: "some state",
        zip: "some zip",
        description: "some description",
        wwoz_id: "some wwoz_id",
        street_address: "some street_address",
        city: "some city",
        website: "some website",
        phone: "some phone",
        email: "some email"
      }

      assert {:ok, %Venue{} = venue} = Venues.create_venue(valid_attrs)
      assert venue.name == "some name"
      assert venue.state == "some state"
      assert venue.zip == "some zip"
      assert venue.description == "some description"
      assert venue.wwoz_id == "some wwoz_id"
      assert venue.street_address == "some street_address"
      assert venue.city == "some city"
      assert venue.website == "some website"
      assert venue.phone == "some phone"
      assert venue.email == "some email"
    end

    test "create_venue/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Venues.create_venue(@invalid_attrs)
    end

    test "update_venue/2 with valid data updates the venue" do
      venue = venue_fixture()

      update_attrs = %{
        name: "some updated name",
        state: "some updated state",
        zip: "some updated zip",
        description: "some updated description",
        wwoz_id: "some updated wwoz_id",
        street_address: "some updated street_address",
        city: "some updated city",
        website: "some updated website",
        phone: "some updated phone",
        email: "some updated email"
      }

      assert {:ok, %Venue{} = venue} = Venues.update_venue(venue, update_attrs)
      assert venue.name == "some updated name"
      assert venue.state == "some updated state"
      assert venue.zip == "some updated zip"
      assert venue.description == "some updated description"
      assert venue.wwoz_id == "some updated wwoz_id"
      assert venue.street_address == "some updated street_address"
      assert venue.city == "some updated city"
      assert venue.website == "some updated website"
      assert venue.phone == "some updated phone"
      assert venue.email == "some updated email"
    end

    test "update_venue/2 with invalid data returns error changeset" do
      venue = venue_fixture()
      assert {:error, %Ecto.Changeset{}} = Venues.update_venue(venue, @invalid_attrs)
      assert venue == Venues.get_venue!(venue.id)
    end

    test "delete_venue/1 deletes the venue" do
      venue = venue_fixture()
      assert {:ok, %Venue{}} = Venues.delete_venue(venue)
      assert_raise Ecto.NoResultsError, fn -> Venues.get_venue!(venue.id) end
    end

    test "change_venue/1 returns a venue changeset" do
      venue = venue_fixture()
      assert %Ecto.Changeset{} = Venues.change_venue(venue)
    end
  end
end
