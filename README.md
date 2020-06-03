# PlugLoggerCee

A plug for formatting your logs for kibana/graylog/etc in the CEE (or lumberjack?) format, or just
json. Like:

```
@cee {"foo":"bar"}
```

## Installation

The package can be installed by adding `cee_log_formatter` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:cee_log_formatter, "~> 0.1"}
  ]
end
```

Then set the format of your logs in production:

```elixir
# config/prod.exs

config :logger, :console,
  level: :info,
  format: {CeeLogFormatter, :format}

```

## Configuration

You can change the prefix line (if you just want json):

```elixir
config :cee_log_formatter,
  prefix: ""
```

By default CeeLogFormatter will try to use Poison to encode and decode JSON, but you can configure it to any other json library that implements `encode!()` and `decode!()` callbacks:

```elixir
config :cee_log_formatter, :json_library, Jason
```

You can add metadata to all your requests via config options:

```elixir
config :cee_log_formatter,
  metadata: [
    app_name: "my-app",
    arbitrary_mfa: {MyMod, :some_func, [:arg1, :arg2]}
  ]
```

The `metadata` config takes a keyword list. If the value is a string, it is used directly in the
log output. If the value is a 3-element tuple, it is expected to be a `{Module, function,
argument-list}`, which is called for every log line to get some current value. If the value
returned from the MFA is not a string, it is ignored.

For instance, you could have the current unix timestamp added to the log with:

```elixir
defmodule TimestampLog do
  def current(resolution) do
    "#{:os.system_time(resolution)}"
  end
end

# in config.exs
config :cee_log_formatter,
  metadata: [
    timestamp: {TimestampLog, :current, [:second]}
  ]
```

You should also use the [PlugLoggerJson](https://github.com/bleacherreport/plug_logger_json)
package, which configures plug to output logs as maps so the formatter gets more info.
