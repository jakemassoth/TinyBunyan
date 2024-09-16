defmodule TinyBunyan.LogsTest do
  use TinyBunyan.DataCase

  alias TinyBunyan.Logs

  describe "logs" do
    alias TinyBunyan.Logs.Log

    import TinyBunyan.LogsFixtures

    @invalid_attrs %{content: nil, fired_at: nil, ingested_at: nil, uuid: nil}

    test "list_logs/0 returns all logs" do
      log = log_fixture()
      assert Logs.list_logs() == [log]
    end

    test "get_log!/1 returns the log with given id" do
      log = log_fixture()
      assert Logs.get_log!(log.id) == log
    end

    test "create_log/1 with valid data creates a log" do
      valid_attrs = %{content: %{}, fired_at: ~U[2024-09-15 19:17:00Z], ingested_at: ~U[2024-09-15 19:17:00Z], uuid: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Log{} = log} = Logs.create_log(valid_attrs)
      assert log.content == %{}
      assert log.fired_at == ~U[2024-09-15 19:17:00Z]
      assert log.ingested_at == ~U[2024-09-15 19:17:00Z]
      assert log.uuid == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Logs.create_log(@invalid_attrs)
    end

    test "update_log/2 with valid data updates the log" do
      log = log_fixture()
      update_attrs = %{content: %{}, fired_at: ~U[2024-09-16 19:17:00Z], ingested_at: ~U[2024-09-16 19:17:00Z], uuid: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Log{} = log} = Logs.update_log(log, update_attrs)
      assert log.content == %{}
      assert log.fired_at == ~U[2024-09-16 19:17:00Z]
      assert log.ingested_at == ~U[2024-09-16 19:17:00Z]
      assert log.uuid == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_log/2 with invalid data returns error changeset" do
      log = log_fixture()
      assert {:error, %Ecto.Changeset{}} = Logs.update_log(log, @invalid_attrs)
      assert log == Logs.get_log!(log.id)
    end

    test "delete_log/1 deletes the log" do
      log = log_fixture()
      assert {:ok, %Log{}} = Logs.delete_log(log)
      assert_raise Ecto.NoResultsError, fn -> Logs.get_log!(log.id) end
    end

    test "change_log/1 returns a log changeset" do
      log = log_fixture()
      assert %Ecto.Changeset{} = Logs.change_log(log)
    end
  end
end
