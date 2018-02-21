defmodule CeeLogFormatterTest do
  use ExUnit.Case

  def test_fun(word) do
    "the word is #{word}"
  end

  # timestamp = {{2014, 12, 30}, {12, 6, 30, 100}}

  test "formats raw messages" do
    assert CeeLogFormatter.format(:info, "hello world", nil, []) ==
             ~s(@cee: {"severity":"info","msg":"hello world"}\n)
  end

  test "formats a json encoded message" do
    data = ~s({"foo":"bar","baz":1})

    assert CeeLogFormatter.format(:info, data, nil, []) ==
             ~s(@cee: {"foo":"bar","baz":1,"severity":"info"}\n)
  end

  test "formats a map message" do
    data = %{"foo" => "bar", "baz" => 1}

    assert CeeLogFormatter.format(:info, data, nil, []) ==
             ~s(@cee: {"foo":"bar","baz":1,"severity":"info"}\n)
  end

  test "includes metadata from config" do
    with_env_config([metadata: [foo: "meta"]], fn ->
      assert CeeLogFormatter.format(:info, "hello", nil, []) ==
               ~s(@cee: {"severity":"info","msg":"hello","foo":"meta"}\n)
    end)
  end

  test "includes multiple metadatas from config" do
    with_env_config([metadata: [foo: "meta", cat: "meow", dog: "bark"]], fn ->
      assert CeeLogFormatter.format(:info, "hello", nil, []) ==
               ~s(@cee: {"severity":"info","msg":"hello","foo":"meta","dog":"bark","cat":"meow"}\n)
    end)
  end

  test "does not error with non-string values" do
    with_env_config([metadata: [foo: 1]], fn ->
      assert CeeLogFormatter.format(:info, "hello", nil, []) ==
               ~s(@cee: {"severity":"info","msg":"hello"}\n)
    end)
  end

  test "calls mfas for values" do
    with_env_config([metadata: [foo: {CeeLogFormatterTest, :test_fun, ["bird"]}]], fn ->
      assert CeeLogFormatter.format(:info, "hello", nil, []) ==
               ~s(@cee: {"severity":"info","msg":"hello","foo":"the word is bird"}\n)
    end)
  end

  def with_env_config([metadata: metadata], func) do
    original_conf = Application.get_env(:cee_log_formatter, :metadata)
    Application.put_env(:cee_log_formatter, :metadata, metadata)

    try do
      func.()
    after
      Application.put_env(:cee_log_formatter, :metadata, original_conf)
    end
  end
end
