defmodule TinyBunyan.EphemeralRepo do
  alias Ecto.Changeset
  import Ecto.Changeset

  defp to_keep() do
    Application.fetch_env!(:tiny_bunyan, :ephemeral_logs_to_keep)
  end

  defp get_key(project_id) do
    "project:#{project_id}"
  end

  defp do_append(log, value) do
    case value do
      nil -> [log]
      _ -> [log | value] |> Enum.sort_by(& &1.fired_at) |> Enum.take(to_keep())
    end
  end

  def append_log(%Changeset{valid?: true} = changeset) do
    log = apply_changes(changeset)

    {:commit, [result | _]} =
      Cachex.get_and_update(
        TinyBunyan.Cachex,
        get_key(log.project_id),
        &do_append(log, &1)
      )

    {:ok, result}
  end

  def append_log(%Changeset{} = changeset) do
    {:error, changeset}
  end

  def get_logs(project_id) do
    {:ok, res} = Cachex.get(TinyBunyan.Cachex, get_key(project_id))

    case res do
      nil -> []
      _ -> res
    end
  end
end
