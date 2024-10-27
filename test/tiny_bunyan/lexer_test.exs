defmodule TinyBunyan.LexerTest do
  use ExUnit.Case

  describe "lexer" do
    alias TinyBunyan.FilterLexer

    test "can lex keywords" do
      query = "and or true false"

      assert FilterLexer.lex(query) == [
               :and,
               :or,
               true,
               false,
               :eof
             ]
    end

    test "can lex simple operators" do
      query = "== != > <"

      assert FilterLexer.lex(query) == [
               :equal,
               :not_equal,
               :greater_than,
               :less_than,
               :eof
             ]
    end

    test "it can lex indetifiers" do
      query = "foo.bar foo_bar foo_bar.foo_baz"

      assert FilterLexer.lex(query) == [
               {:identifier, "foo"},
               :dot,
               {:identifier, "bar"},
               {:identifier, "foo_bar"},
               {:identifier, "foo_bar"},
               :dot,
               {:identifier, "foo_baz"},
               :eof
             ]
    end

    test "can lex strings" do
      query = ~s("test" "test2")

      assert FilterLexer.lex(query) == [
               {:string, "test"},
               {:string, "test2"},
               :eof
             ]
    end

    test "can lex integers" do
      query = "123 1 0"

      assert FilterLexer.lex(query) == [
               {:number, "123"},
               {:number, "1"},
               {:number, "0"},
               :eof
             ]
    end

    test "can lex more floats" do
      query = "4.55 0.1"

      assert FilterLexer.lex(query) == [
               {:number, "4.55"},
               {:number, "0.1"},
               :eof
             ]
    end

    test "can lex complicated query" do
      query = ~s(log.content.foo == "bar" and log.fired_at > "some date")

      assert FilterLexer.lex(query) == [
               {:identifier, "log"},
               :dot,
               {:identifier, "content"},
               :dot,
               {:identifier, "foo"},
               :equal,
               {:string, "bar"},
               :and,
               {:identifier, "log"},
               :dot,
               {:identifier, "fired_at"},
               :greater_than,
               {:string, "some date"},
               :eof
             ]
    end
  end
end
