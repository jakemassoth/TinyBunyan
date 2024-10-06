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
      assert_receive {TinyBunyan.Logs, :created, _}
    end

  end
end
