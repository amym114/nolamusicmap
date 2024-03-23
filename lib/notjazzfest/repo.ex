defmodule Notjazzfest.Repo do
  use Ecto.Repo,
    otp_app: :notjazzfest,
    adapter: Ecto.Adapters.Postgres
end
