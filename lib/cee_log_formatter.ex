defmodule CeeLogFormatter do
  @moduledoc """
  Custom @cee formatter for logs
  """

  alias Logger.Formatter

  @json_library Application.fetch_env!(:cee_log_formatter, :json_library)

  @spec format(
          Logger.level(),
          Logger.message(),
          Formatter.time(),
          Keyword.t()
        ) :: IO.chardata()

  def format(level, "{\"" <> _ = msg, timestamp, metadata) do
    format(level, @json_library.decode!(msg), timestamp, metadata)
  end

  def format(level, %{} = msg, _timestamp, metadata) do
    msg
    |> Map.put(:severity, level)
    |> merge_app_config()
    |> Map.merge(Enum.into(metadata, %{}))
    |> @json_library.encode!()
    |> cee_line()
  end

  def format(level, msg, timestamp, metadata) do
    message =
      [:message]
      |> Logger.Formatter.format(level, msg, timestamp, metadata)
      |> to_string()

    format(level, %{msg: message}, timestamp, metadata)
  end

  defp cee_line(json) do
    prefix = Application.get_env(:cee_log_formatter, :prefix, "@cee: ")
    "#{prefix}#{json}\n"
  end

  defp merge_app_config(msg) do
    case Application.get_env(:cee_log_formatter, :metadata) do
      list when is_list(list) ->
        put_conf(msg, list)

      _ ->
        msg
    end
  end

  defp put_conf(msg, []), do: msg

  defp put_conf(msg, [{key, value} | rest]) when is_atom(key) and is_binary(value) do
    Map.put(msg, key, value)
    |> put_conf(rest)
  end

  defp put_conf(msg, [{key, {mod, fun, args}} | rest])
       when is_atom(key) and is_atom(mod) and is_atom(fun) and is_list(args) do
    try do
      value = apply(mod, fun, args) |> String.Chars.to_string()
      put_conf(msg, [{key, value} | rest])
    rescue
      Protocol.UndefinedError -> put_conf(msg, rest)
      _ -> put_conf(msg, rest)
    end
  end

  defp put_conf(msg, [_ | rest]), do: put_conf(msg, rest)
end
