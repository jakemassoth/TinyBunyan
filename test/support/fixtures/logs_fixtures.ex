defmodule TinyBunyan.LogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TinyBunyan.Logs` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{
        content: %{},
        content: "some content",
        fired_at: ~U[2024-09-15 19:17:00Z],
        ingested_at: ~U[2024-09-15 19:17:00Z],
        uuid: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> TinyBunyan.Logs.create_log()

    log
  end
end
