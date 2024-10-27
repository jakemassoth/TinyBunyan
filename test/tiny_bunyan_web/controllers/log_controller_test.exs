defmodule TinyBunyanWeb.LogControllerTest do
  use TinyBunyanWeb.ConnCase

  @create_attrs %{
    content: %{},
    fired_at: ~U[2024-09-16 19:23:00Z],
    project_id: 1
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
    # TODO this one fails right now because it tries to fetch a single log 
    # from the ephemeral cache, need to figure out how to handle this
    test "renders log when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/projects/1/logs", log: @create_attrs)
      assert %{"uuid" => uuid} = json_response(conn, 201)["data"]
      conn = get(conn, ~p"/api/v1/projects/1/logs/#{uuid}")

      assert %{
               "content" => %{},
               "fired_at" => "2024-09-16T19:23:00Z",
               "uuid" => ^uuid
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/v1/projects/1/logs", log: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
