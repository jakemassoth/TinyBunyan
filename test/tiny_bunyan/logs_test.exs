defmodule TinyBunyan.LogsTest do
  use TinyBunyan.DataCase
  alias TinyBunyan.Logs
  import TinyBunyan.LogsFixtures
  import TinyBunyan.ProjectsFixtures

  describe "logs" do
    test "create a log" do
      project = project_fixture()
      Logs.subscribe(project.project_id)
      
      log_fixture(%{project_id: project.project_id})
      logs = Logs.list_logs(project.project_id)
      assert length(logs) == 1
      assert_receive {TinyBunyan.Logs, :created, _}
    end

    test "create more logs than the configured max, they should get trimmed" do
      project = project_fixture()
      Logs.subscribe(project.project_id)
      
      max = Application.fetch_env!(:tiny_bunyan, :ephemeral_logs_to_keep)
      for _ <- 1..(max + 5) do
        log_fixture(%{project_id: project.project_id})
        assert_receive {TinyBunyan.Logs, :created, _}
      end

      logs = Logs.list_logs(project.project_id)
      assert length(logs) == max
    end

  end
end
