defmodule TinyBunyan.FiltersTest do
  use TinyBunyan.DataCase

  alias TinyBunyan.Filters

  describe "filters" do
    alias TinyBunyan.Filters.Filter

    import TinyBunyan.FiltersFixtures

    @invalid_attrs %{project_id: 1, query: %{}}

    test "list_filters/0 returns all filters" do
      filter = filter_fixture()
      assert Filters.list_filters(filter.project_id) == [filter]
    end

    test "get_filter!/1 returns the filter with given id" do
      filter = filter_fixture()
      assert Filters.get_filter!(filter.uuid, filter.project_id) == filter
    end

    test "create_filter/1 with valid data creates a filter" do
      valid_attrs = %{project_id: 1, query: "log.content.foo == \"bar\""}

      assert {:ok, %Filter{project_id: 1, query: "log.content.foo == \"bar\""}} =
               Filters.create_filter(valid_attrs)
    end

    test "create_filter/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Filters.create_filter(@invalid_attrs)
    end

    test "update_filter/2 with valid data updates the filter" do
      filter = filter_fixture()
      update_attrs = %{query: "log.content.foo == \"baz\""}

      assert {:ok, %Filter{query: "log.content.foo == \"baz\""}} =
               Filters.update_filter(filter, update_attrs)
    end

    test "update_filter/2 with invalid data returns error changeset" do
      filter = filter_fixture()
      assert {:error, %Ecto.Changeset{}} = Filters.update_filter(filter, @invalid_attrs)
      assert filter == Filters.get_filter!(filter.uuid, filter.project_id)
    end

    test "delete_filter/1 deletes the filter" do
      filter = filter_fixture()
      assert {:ok, %Filter{}} = Filters.delete_filter(filter)

      assert_raise Ecto.NoResultsError, fn ->
        Filters.get_filter!(filter.uuid, filter.project_id)
      end
    end

    test "change_filter/1 returns a filter changeset" do
      filter = filter_fixture()
      assert %Ecto.Changeset{} = Filters.change_filter(filter)
    end
  end
end
