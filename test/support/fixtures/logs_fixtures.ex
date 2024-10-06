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

    # don't create a project if we pass a project id 
    project_id = case attrs do
      {project_id} -> project_id
      _ -> project_fixture().project_id
    end

    {:ok, log} = attrs
     |> Enum.into(%{
       fired_at: DateTime.utc_now(),
       content: %{},
       project_id: project_id
     })
      |> TinyBunyan.Logs.create_log()

    log

  end
end
