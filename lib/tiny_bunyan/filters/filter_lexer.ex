defmodule TinyBunyan.FilterLexer do
  @moduledoc """
  A simple lexer for the filter language.
  """
  @type keyword_token ::
          :and
          | :or
          | true
          | false
  @type token ::
          keyword_token()
          | :eof
          | :dot
          | {:identifier, String.t()}
          | :equal
          | :not_equal
          | :greater_than
          | :less_than
          | {:string, String.t()}
          | {:number, String.t()}
          | {:illegal, String.t()}

  defguardp is_whitespace(c) when c in ~c[ \r\n\t]
  defguardp is_letter(c) when c in ?a..?z or c in ?A..?Z or c == ?_
  defguardp is_digit(c) when c in ?0..?9

  @doc """
  Lex a given input. Retun a set of tokens.
  """
  @spec lex(String.t()) :: [token()]
  def lex(input) when is_binary(input) do
    do_lex(input, [])
  end

  @spec do_lex(input :: String.t(), [token()]) :: [token()]
  defp do_lex(<<>>, tokens) do
    [:eof | tokens] |> Enum.reverse()
  end

  defp do_lex(<<c::8, rest::binary>>, tokens) when is_whitespace(c) do
    do_lex(rest, tokens)
  end

  defp do_lex(input, tokens) do
    {token, rest} = lex_token(input)
    do_lex(rest, [token | tokens])
  end

  @spec lex_token(input :: String.t()) :: {token(), rest :: String.t()}
  defp lex_token(<<"==", rest::binary>>), do: {:equal, rest}
  defp lex_token(<<"!=", rest::binary>>), do: {:not_equal, rest}
  defp lex_token(<<">", rest::binary>>), do: {:greater_than, rest}
  defp lex_token(<<"<", rest::binary>>), do: {:less_than, rest}
  defp lex_token(<<".", rest::binary>>), do: {:dot, rest}
  defp lex_token(<<c::8, rest::binary>>) when is_letter(c), do: read_identifier(rest, <<c>>)
  defp lex_token(<<c::8, rest::binary>>) when is_digit(c), do: read_number(rest, <<c>>)
  defp lex_token(<<"\"", c::8, rest::binary>>), do: read_string(rest, <<c>>)
  defp lex_token(<<"'", c::8, rest::binary>>), do: read_string(rest, <<c>>)
  defp lex_token(<<c::8, rest::binary>>), do: {{:illegal, <<c>>}, rest}

  @spec read_string(String.t(), iodata()) :: {token(), String.t()}
  defp read_string(<<c::8, rest::binary>>, acc) when c != ?' and c != ?" do
    read_string(rest, [acc | <<c>>])
  end

  # this guard is slightly redundant but good to check the assumption regardless
  # We need to parse over the closing quote
  defp read_string(<<c::8, rest::binary>>, acc) when c == ?' or c == ?" do
    {{:string, IO.iodata_to_binary(acc)}, rest}
  end

  @spec read_identifier(String.t(), iodata()) :: {token(), String.t()}
  defp read_identifier(<<c::8, rest::binary>>, acc) when is_letter(c) do
    read_identifier(rest, [acc | <<c>>])
  end

  defp read_identifier(rest, acc) do
    {IO.iodata_to_binary(acc) |> tokenize_word(), rest}
  end

  @spec read_number(String.t(), iodata()) :: {{:number, String.t()}, String.t()}
  # Lex floats, we check if we are on a "." and the next char is a digit
  defp read_number(<<c::8, c2::8, rest::binary>>, acc) when c == ?. and is_digit(c2) do
    read_number(rest, [[acc | <<c>>] | <<c2>>])
  end

  # if we are on a . and the next thing is not a digit, this is an illegal token
  defp read_number(<<c::8, c2::8, rest::binary>>, acc) when c == ?. and not is_digit(c2) do
    {:illegal, IO.iodata_to_binary([rest, acc])}
  end

  # lex integers
  defp read_number(<<c::8, rest::binary>>, acc) when is_digit(c) do
    read_number(rest, [acc | <<c>>])
  end

  defp read_number(rest, acc) do
    {{:number, IO.iodata_to_binary(acc)}, rest}
  end

  @spec tokenize_word(String.t()) :: keyword_token() | {:ident, String.t()}
  defp tokenize_word("and"), do: :and
  defp tokenize_word("or"), do: :or
  defp tokenize_word("true"), do: true
  defp tokenize_word("false"), do: false
  defp tokenize_word(ident), do: {:identifier, ident}
end
