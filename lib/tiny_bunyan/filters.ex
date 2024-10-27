defmodule TinyBunyan.Filters do
  @moduledoc """
  The Filters context.
  """

  import Ecto.Query, warn: false
  alias TinyBunyan.Repo

  alias TinyBunyan.Filters.Filter

  @doc """
  Returns the list of filters.

  ## Examples

      iex> list_filters()
      [%Filter{}, ...]

  """
  def list_filters(project_id) do
    from(f in Filter, where: f.project_id == ^project_id)
    |> Repo.all()
  end

  @doc """
  Gets a single filter.

  Raises `Ecto.NoResultsError` if the Filter does not exist.

  ## Examples

      iex> get_filter!(123)
      %Filter{}

      iex> get_filter!(456)
      ** (Ecto.NoResultsError)

  """
  def get_filter!(uuid, project_id) do
    from(f in Filter, where: f.project_id == ^project_id and f.uuid == ^uuid)
    |> Repo.one!()
  end

  @doc """
  Creates a filter.

  ## Examples

      iex> create_filter(%{field: value})
      {:ok, %Filter{}}

      iex> create_filter(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_filter(attrs \\ %{}) do
    %Filter{}
    |> Filter.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a filter.

  ## Examples

      iex> update_filter(filter, %{field: new_value})
      {:ok, %Filter{}}

      iex> update_filter(filter, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_filter(%Filter{} = filter, attrs) do
    filter
    |> Filter.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a filter.

  ## Examples

      iex> delete_filter(filter)
      {:ok, %Filter{}}

      iex> delete_filter(filter)
      {:error, %Ecto.Changeset{}}

  """
  def delete_filter(%Filter{} = filter) do
    Repo.delete(filter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking filter changes.

  ## Examples

      iex> change_filter(filter)
      %Ecto.Changeset{data: %Filter{}}

  """
  def change_filter(%Filter{} = filter, attrs \\ %{}) do
    Filter.changeset(filter, attrs)
  end
end
