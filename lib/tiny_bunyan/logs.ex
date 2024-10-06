defmodule TinyBunyan.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Phoenix.PubSub
  alias TinyBunyan.Repo
  alias TinyBunyan.EphemeralRepo

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
    |> Enum.concat(EphemeralRepo.get_logs(project_id))
    |> Enum.sort_by(& &1.fired_at)
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
  def get_log!(uuid, project_id) do
    from(l in Log, where: l.project_id == ^project_id and l.uuid == ^uuid)
    |> Repo.one!()
  end

  defguardp should_save(_log) when false

  @doc """
  Creates a log.

  ## Examples

      iex> create_log(%{field: value})
      {:ok, %Log{}}

      iex> create_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_log(attrs \\ %{})

  def create_log(attrs) when should_save(attrs) do
    with {:ok, result} <- 
      %Log{}
      |> Log.changeset(attrs)
      |> Repo.insert() do
      notify_subscribers({:ok, result}, :created)
    end
  end

  def create_log(attrs) when not should_save(attrs) do
    with {:ok, result} <- 
      %Log{}
      |> Log.changeset(attrs)
      |> EphemeralRepo.append_log() do
      notify_subscribers({:ok, result}, :created)
    end
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
