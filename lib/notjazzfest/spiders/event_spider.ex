defmodule Notjazzfest.Spider.EventSpider do
  use Crawly.Spider
  require Logger

  @impl Crawly.Spider
  def base_url(), do: "https://www.wwoz.org/"

  @impl Crawly.Spider
  def init() do
    Logger.warning("HEY GIRL INIT")
    [start_urls: ["https://www.wwoz.org/calendar/livewire-music?date=2024-04-26"]]
  end

  @impl Crawly.Spider
  def parse_item(response) do
    Logger.warning("HEY GIRL PARSIN'")

    # Parse response body to document
    {:ok, document} = Floki.parse_document(response.body)

    all_shows =
      document
      |> Floki.find(".livewire-listing")
      |> Floki.find(".panel")
      |> Enum.map(fn venue ->
        %{
          venue_name:
            String.trim(Floki.find(venue, ".panel-heading .panel-title a") |> Floki.text()),
          events:
            venue
            |> Floki.find(".panel-body")
            |> Floki.find(".row")
            |> Enum.map(fn row ->
              %{
                name:
                  String.trim(
                    Floki.find(row, "p.truncate")
                    |> Floki.text()
                  ),
                date_and_time:
                  String.trim(
                    Floki.find(row, "p:last-of-type")
                    |> Floki.text()
                  )
              }
            end),
          venue_url: Floki.find(venue, ".panel-heading .panel-title a") |> Floki.attribute("href")
        }
      end)

    all_shows
    |> Enum.map(fn show_venue ->
      Logger.info("\n\nShow Venue: ")
      Logger.warning(inspect(show_venue.venue_name))
      Logger.info(inspect(show_venue.venue_url))

      show_venue.events
      |> Enum.map(fn show ->
        Logger.info(inspect(show.name))
        Logger.info(inspect(show.date_and_time))
      end)
    end)

    # Logger.warning(inspect(all_shows))
    # %Crawly.ParsedItem{}
    %Crawly.ParsedItem{items: all_shows, requests: []}
    # %Crawly.ParsedItem{items: all_shows, requests: next_requests}
  end
end
