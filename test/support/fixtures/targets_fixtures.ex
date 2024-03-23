defmodule Notjazzfest.TargetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Notjazzfest.Targets` context.
  """

  @doc """
  Generate a target.
  """
  def target_fixture(attrs \\ %{}) do
    {:ok, target} =
      attrs
      |> Enum.into(%{
        lat: 120.5,
        lng: 120.5,
        name: "some name"
      })
      |> Notjazzfest.Targets.create_target()

    target
  end
end
