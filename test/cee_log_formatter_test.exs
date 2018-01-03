defmodule CeeLogFormatterTest do
  use ExUnit.Case

  #timestamp = {{2014, 12, 30}, {12, 6, 30, 100}}

  test "formats raw messages" do
    assert CeeLogFormatter.format(:info, "hello world", nil, []) == ~s(@cee: {"severity":"info","msg":"hello world"}\n)
  end

  test "formats a json encoded message" do
    data = ~s({"foo":"bar","baz":1})
    assert CeeLogFormatter.format(:info, data, nil, []) == ~s(@cee: {"foo":"bar","baz":1,"severity":"info"}\n)
  end

  test "formats a map message" do
    data = %{"foo" => "bar", "baz" => 1}
    assert CeeLogFormatter.format(:info, data, nil, []) == ~s(@cee: {"foo":"bar","baz":1,"severity":"info"}\n)
  end
end
