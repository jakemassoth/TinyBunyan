defmodule TinyBunyan.LogsFixtures do
  import TinyBunyan.ProjectsFixtures
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TinyBunyan.Logs` context.
  """

  @doc """
  geenrates a log
  """
  def log_fixture(attrs \\ %{}) do
    project = project_fixture()

    {:ok, log} = attrs
     |> Enum.into(%{
       fired_at: DateTime.utc_now(),
       content: %{},
       project_id: project.project_id
     })
      |> TinyBunyan.Logs.create_log()

    log

  end
end
