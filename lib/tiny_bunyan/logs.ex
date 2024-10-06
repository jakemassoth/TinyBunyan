defmodule TinyBunyan.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Phoenix.PubSub
  alias TinyBunyan.Repo

  alias TinyBunyan.Logs.Log

  def subscribe(project_id) do
    PubSub.subscribe(TinyBunyan.PubSub, "logs:#{project_id}")
  end

  @doc """
  Returns the list of logs.

  ## Examples

      iex> list_logs()
      [%Log{}, ...]

  """
  def list_logs(project_id) do
    from(l in Log, where: l.project_id == ^project_id)
    |> Repo.all()
  end

  @doc """
  Gets a single log.

  Raises `Ecto.NoResultsError` if the Log does not exist.

  ## Examples

      iex> get_log!(123)
      %Log{}

      iex> get_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_log!(id, project_id) do
    from(l in Log, where: l.project_id == ^project_id and l.id == ^id)
    |> Repo.one!()
  end

  @doc """
  Creates a log.

  ## Examples

      iex> create_log(%{field: value})
      {:ok, %Log{}}

      iex> create_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_log(attrs \\ %{}) do
    with {:ok, result} <- 
      %Log{}
      |> Log.changeset(attrs)
      |> Repo.insert() do
      notify_subscribers({:ok, result}, :created)
    end
  end

  @doc """
  Updates a log.

  ## Examples

      iex> update_log(log, %{field: new_value})
      {:ok, %Log{}}

      iex> update_log(log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_log(%Log{} = log, attrs) do
    log
    |> Log.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a log.

  ## Examples

      iex> delete_log(log)
      {:ok, %Log{}}

      iex> delete_log(log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_log(%Log{} = log) do
    Repo.delete(log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking log changes.

  ## Examples

      iex> change_log(log)
      %Ecto.Changeset{data: %Log{}}

  """
  def change_log(%Log{} = log, attrs \\ %{}) do
    Log.changeset(log, attrs)
  end

  defp notify_subscribers({:ok, result}, event) do
    PubSub.broadcast(
      TinyBunyan.PubSub, 
      "logs:#{result.project_id}", 
      {__MODULE__, event, result}
    )
    {:ok, result}
  end
end
