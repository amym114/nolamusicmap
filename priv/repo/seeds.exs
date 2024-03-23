# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Notjazzfest.Repo.insert!(%Notjazzfest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[
  {"Target 1", 1.2953493105364986, 103.85826194711629},
  {"Target 2", 1.2946628404229832, 103.86017167980194},
  {"Target 3", 1.2947915535834391, 103.85798299739815},
  {"Target 4", 1.2935473261018144, 103.8506659312996}
]
|> Enum.map(fn {name, lat, lon} ->
  now = DateTime.utc_now(:second)

  %{
    name: name,
    inserted_at: now,
    updated_at: now,
    lat: lat,
    lng: lon
  }
end)
|> then(&Notjazzfest.Repo.insert_all(Notjazzfest.Targets.Target, &1, on_conflict: :nothing))
