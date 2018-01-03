# PlugLoggerCee

A plug for formatting your logs for kibana/graylog/etc in the CEE (or lumberjack?) format. Like:

```
@cee {"foo":"bar"}
```

## Installation

The package can be installed by adding `cee_log_formatter` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:cee_log_formatter, "~> 0.1.0"}
  ]
end
```

Then set the format of your logs in production:

```
# config/prod.exs

config :logger, :console,
  level: :info,
  format: {CeeLogFormatter, :format}

```

You should also use the [PlugLoggerJson](https://github.com/bleacherreport/plug_logger_json)
package, which configures plug to output logs as maps so the formatter gets more info.
