defmodule TinyBunyanWeb.LogControllerTest do
  use TinyBunyanWeb.ConnCase

  alias TinyBunyan.Logs.Log
  import TinyBunyan.LogsFixtures

  @create_attrs %{
    content: %{},
    fired_at: ~U[2024-09-16 19:23:00Z],
    uuid: "7488a646-e31f-11e4-aace-600308960662",
    project_id: 1
  }
  @update_attrs %{
    content: %{},
    fired_at: ~U[2024-09-17 19:23:00Z],
    uuid: "7488a646-e31f-11e4-aace-600308960668",
  }
  @invalid_attrs %{content: nil, fired_at: nil, uuid: nil, project_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all logs", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/projects/1/logs")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create log" do
    test "renders log when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/projects/1/logs", log: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]
      IO.inspect(id)

      conn = get(conn, ~p"/api/v1/projects/1/logs/#{id}")

      assert %{
               "id" => ^id,
               "content" => %{},
               "fired_at" => "2024-09-16T19:23:00Z",
               "uuid" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/projects/1/logs", log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update log" do
    setup [:create_log]

    test "renders log when data is valid", %{conn: conn, log: %Log{id: id, project_id: project_id} = log} do
      conn = put(conn, ~p"/api/v1/projects/#{log.project_id}/logs/#{log}", log: @update_attrs)
      assert %{"id" => ^id, "project_id" => ^project_id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/v1/projects/#{project_id}/logs/#{id}")

      assert %{
               "id" => ^id,
               "content" => %{},
               "fired_at" => "2024-09-17T19:23:00Z",
               "uuid" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, log: log} do
      conn = put(conn, ~p"/api/v1/projects/#{log.project_id}/logs/#{log}", log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete log" do
    setup [:create_log]

    test "deletes chosen log", %{conn: conn, log: log} do
      conn = delete(conn, ~p"/api/v1/projects/#{log.project_id}/logs/#{log}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/v1/projects/#{log.project_id}/logs/#{log}")
      end
    end
  end

  defp create_log(_) do
    log = log_fixture()
    %{log: log}
  end
end
