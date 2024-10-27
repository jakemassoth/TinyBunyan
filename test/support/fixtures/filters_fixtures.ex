defmodule TinyBunyan.FiltersFixtures do
  import TinyBunyan.ProjectsFixtures

  @moduledoc """
  This module defines test helpers for creating
  entities via the `TinyBunyan.Filters` context.
  """

  @doc """
  Generate a filter.
  """
  def filter_fixture(attrs \\ %{}) do
    project_id =
      case attrs do
        {project_id} -> project_id
        _ -> project_fixture().project_id
      end

    {:ok, filter} =
      attrs
      |> Enum.into(%{
        query: "log.content.foo == \"bar\"",
        project_id: project_id
      })
      |> TinyBunyan.Filters.create_filter()

    filter
  end
end
