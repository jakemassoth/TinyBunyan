defmodule TinyBunyan.LogsTest do
  use TinyBunyan.DataCase
  alias TinyBunyan.Logs

  describe "logs" do
    test "create a log" do
      Logs.subscribe()
      
      res = Logs.create_log(%{
        content: %{foo: "bar"},
        fired_at: DateTime.utc_now()
      })

      assert match?({:ok, _}, res)
      
      assert_receive {TinyBunyan.Logs, :created, _}
    end

  end
end
