defmodule TinyBunyanWeb.LogControllerTest do
  use TinyBunyanWeb.ConnCase

  import TinyBunyan.LogsFixtures

  alias TinyBunyan.Logs.Log

  @create_attrs %{
    content: %{},
    fired_at: ~U[2024-09-16 19:23:00Z],
    uuid: "7488a646-e31f-11e4-aace-600308960662"
  }
  @update_attrs %{
    content: %{},
    fired_at: ~U[2024-09-17 19:23:00Z],
    uuid: "7488a646-e31f-11e4-aace-600308960668"
  }
  @invalid_attrs %{content: nil, fired_at: nil, uuid: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all logs", %{conn: conn} do
      conn = get(conn, ~p"/api/logs")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create log" do
    test "renders log when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/logs", log: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/logs/#{id}")

      assert %{
               "id" => ^id,
               "content" => %{},
               "fired_at" => "2024-09-16T19:23:00Z",
               "uuid" => "7488a646-e31f-11e4-aace-600308960662"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/logs", log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update log" do
    setup [:create_log]

    test "renders log when data is valid", %{conn: conn, log: %Log{id: id} = log} do
      conn = put(conn, ~p"/api/logs/#{log}", log: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/logs/#{id}")

      assert %{
               "id" => ^id,
               "content" => %{},
               "fired_at" => "2024-09-17T19:23:00Z",
               "uuid" => "7488a646-e31f-11e4-aace-600308960668"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, log: log} do
      conn = put(conn, ~p"/api/logs/#{log}", log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete log" do
    setup [:create_log]

    test "deletes chosen log", %{conn: conn, log: log} do
      conn = delete(conn, ~p"/api/logs/#{log}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/logs/#{log}")
      end
    end
  end

  defp create_log(_) do
    log = log_fixture()
    %{log: log}
  end
end
