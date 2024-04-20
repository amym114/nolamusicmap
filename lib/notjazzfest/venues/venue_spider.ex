defmodule Notjazzfest.Spider.VenueSpider do
  use Crawly.Spider
  require Logger

  alias Notjazzfest.Venues
  alias Notjazzfest.Events

  @impl Crawly.Spider
  def base_url(), do: "https://www.wwoz.org"

  @impl Crawly.Spider
  def init() do
    [start_urls: build_start_urls(Date.utc_today())]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    # Parse response body to document
    {:ok, document} = Floki.parse_document(response.body)

    case String.contains?(response.request_url, "/organizations/") do
      false -> parse_show_list(document, response.request_url)
      true -> parse_venue_page(document, response.request_url)
    end

    # %Crawly.ParsedItem{items: all_shows, requests: []}
  end

  defp parse_show_list(document, _url) do
    all_shows =
      document
      |> Floki.find(".livewire-listing")
      |> Floki.find(".panel")
      |> Enum.map(fn venue ->
        %{
          name:
            String.trim(Floki.find(venue, ".panel-heading .panel-title a") |> Floki.text()),
          venue_url:
            Floki.find(venue, ".panel-heading .panel-title a") |> Floki.attribute("href"),
          events:
            venue
            |> Floki.find(".panel-body")
            |> Floki.find(".row")
            |> Enum.map(fn row ->
              %{
                title:
                  String.trim(
                    Floki.find(row, "p.truncate")
                    |> Floki.text()
                  ),
                date_and_time:
                  String.trim(
                    Floki.find(row, "p:last-of-type")
                    |> Floki.text()
                  ),
                wwoz_id:
                  extract_last_text(Floki.find(row, "p.truncate a") |> Floki.attribute("href"))
              }
            end),
          wwoz_venue_id:
            extract_last_text(
              Floki.find(venue, ".panel-heading .panel-title a")
              |> Floki.attribute("href")
            )
        }
      end)

    all_shows
    |> Enum.map(fn show_venue ->
      show_venue.events
      |> Enum.map(fn show ->
        # Create a new Event struct with the extracted data
        event = %Events.Event{
          title: show.title,
          date: show.date_and_time,
          wwoz_venue_id: show_venue.wwoz_venue_id,
          wwoz_id: show.wwoz_id
        }

        # Call insert_or_update_event with the event struct and attributes
        Events.insert_or_update_event(event, %{
          title: show.title,
          date: show.date_and_time,
          wwoz_venue_id: show_venue.wwoz_venue_id,
          wwoz_id: show.wwoz_id
        })
      end)
    end)

    requests =
      all_shows
      |> Enum.map(fn show_venue ->
        Crawly.Utils.request_from_url(base_url() <> Enum.join(show_venue.venue_url))
      end)

    %{items: all_shows, requests: requests}
  end

  defp parse_venue_page(document, url) do
    venues =
      [
        %{
          wwoz_venue_id: extract_last_text(url),
          name:
            String.trim(
              document
              |> Floki.find(".page-title")
              |> Floki.text()
            ),
          street_address:
            document
            |> Floki.find(".thoroughfare")
            |> Floki.text(),
          city:
            document
            |> Floki.find(".locality")
            |> Floki.text(),
          state:
            document
            |> Floki.find(".state")
            |> Floki.text(),
          zip:
            document
            |> Floki.find(".postal-code")
            |> Floki.text()
        }

      ]

      venues
      |> Enum.map(fn show_venue ->

        venue = %Venues.Venue{
          wwoz_venue_id: show_venue.wwoz_venue_id,
          name: show_venue.name,
          street_address: show_venue.street_address,
          city: show_venue.city,
          state: show_venue.state
        }

        Venues.insert_or_update_venue(venue, %{
          wwoz_venue_id: show_venue.wwoz_venue_id,
          name: show_venue.name,
          street_address: show_venue.street_address,
          city: show_venue.city,
          state: show_venue.state
        })


        end)

    %{items: venues, requests: []}
  end

  defp build_start_urls(today) do
    date_range = Date.range(today, Date.add(today, 4)) |> Enum.to_list()

    Enum.map(date_range, fn date ->
      base_url() <> "/calendar/livewire-music?" <> Date.to_string(date)
    end)
  end

  defp extract_last_text(text) when is_list(text) do
    text = Enum.join(text)
    extract_last_text(text)
  end

  defp extract_last_text(text) when is_binary(text) do
    parts = String.split(text, "/")
    List.last(parts)
  end
end
