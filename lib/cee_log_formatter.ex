defmodule CeeLogFormatter do
  @moduledoc """
  Custom @cee formatter for logs
  """

  alias Logger.Formatter

  @spec format(
    Logger.level,
    Logger.message,
    Formatter.time,
    Keyword.t
  ) :: IO.chardata

  def format(level, ("{\"" <> _) = msg, timestamp, metadata) do
    format(level, Poison.decode!(msg), timestamp, metadata)
  end
  def format(level, %{} = msg, _timestamp, metadata) do
    msg
    |> Map.put(:severity, level)
    |> Map.merge(Enum.into(metadata, %{}))
    |> Poison.encode!
    |> cee_line()
  end
  def format(level, msg, timestamp, metadata) do
    message = [:message]
    |> Logger.Formatter.format(level, msg, timestamp, metadata)
    |> to_string()

    format(level, %{msg: message}, timestamp, metadata)
  end

  defp cee_line(json) do
    "@cee: #{json}\n"
  end
end
