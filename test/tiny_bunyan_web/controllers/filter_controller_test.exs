defmodule TinyBunyanWeb.FilterControllerTest do
  use TinyBunyanWeb.ConnCase

  import TinyBunyan.FiltersFixtures

  @create_attrs %{project_id: 1, query: "log.content.foo == \"bar\""}
  @update_attrs %{query: "log.content.foo == \"baz\""}
  @invalid_attrs %{query: %{}}

  describe "index" do
    setup [:create_filter]

    test "lists all filters", %{conn: conn, filter: filter} do
      conn = get(conn, ~p"/projects/#{filter.project_id}/filters")
      assert html_response(conn, 200) =~ "Listing Filters"
    end
  end

  describe "new filter" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/projects/1/filters/new")
      assert html_response(conn, 200) =~ "New Filter"
    end
  end

  describe "create filter" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/projects/#{@create_attrs.project_id}/filters", filter: @create_attrs)

      project_id = Integer.to_string(@create_attrs.project_id)
      assert %{project_id: ^project_id, id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/projects/#{@create_attrs.project_id}/filters/#{id}"

      conn = get(conn, ~p"/projects/#{@create_attrs.project_id}/filters/#{id}")
      assert html_response(conn, 200) =~ "Filter #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/projects/1/filters", filter: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Filter"
    end
  end

  describe "edit filter" do
    setup [:create_filter]

    test "renders form for editing chosen filter", %{conn: conn, filter: filter} do
      conn = get(conn, ~p"/projects/#{filter.project_id}/filters/#{filter.uuid}/edit")
      assert html_response(conn, 200) =~ "Edit Filter"
    end
  end

  describe "update filter" do
    setup [:create_filter]

    test "redirects when data is valid", %{conn: conn, filter: filter} do
      conn =
        put(conn, ~p"/projects/#{filter.project_id}/filters/#{filter}", filter: @update_attrs)

      project_id = Integer.to_string(filter.project_id)
      uuid = filter.uuid

      assert %{project_id: ^project_id, id: ^uuid} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/projects/#{project_id}/filters/#{uuid}"

      conn = get(conn, ~p"/projects/#{project_id}/filters/#{uuid}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, filter: filter} do
      conn =
        put(conn, ~p"/projects/#{filter.project_id}/filters/#{filter}", filter: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Filter"
    end
  end

  describe "delete filter" do
    setup [:create_filter]

    test "deletes chosen filter", %{conn: conn, filter: filter} do
      conn = delete(conn, ~p"/projects/#{filter.project_id}/filters/#{filter}")

      assert redirected_to(conn) == ~p"/projects/#{filter.project_id}/filters"

      assert_error_sent(404, fn ->
        get(conn, ~p"/projects/#{filter.project_id}/filters/#{filter}")
      end)
    end
  end

  defp create_filter(_) do
    filter = filter_fixture()
    %{filter: filter}
  end
end
