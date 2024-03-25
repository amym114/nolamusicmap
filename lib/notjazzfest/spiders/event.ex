defmodule Notjazzfest.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :title, :string
    field :date, :utc_datetime
    field :venue, :string
    field :description, :string
    timestamps()
  end

    @spec changeset(
            {map(), map()}
            | %{
                :__struct__ => atom() | %{:__changeset__ => map(), optional(any()) => any()},
                optional(atom()) => any()
              },
            :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
          ) :: Ecto.Changeset.t()
    @doc false
    def changeset(target, attrs) do
      target
      |> cast(attrs, [:title, :date, :venue, :description])
      |> validate_required([:title, :date, :venue])
    end

end
