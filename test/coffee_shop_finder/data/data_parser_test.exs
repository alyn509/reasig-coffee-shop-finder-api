defmodule CoffeeShopFinder.DataParserTest do
  use ExUnit.Case, async: true

  alias CoffeeShopFinder.Data.DataParser

  test "parses valid rows" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Shop B", "3.0", "4.0"]
    ]

    {status, shops} = DataParser.parse(rows)

    assert status == :ok
    assert length(shops) == 2
    assert Enum.any?(shops, &(&1.name == "Shop A"))
  end

  test "skips malformed rows" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Shop B", "3.0", "4.0"],
      ["Broken", "abc", "xyz"]
    ]

    {status, shops} = DataParser.parse(rows)

    assert status == :ok
    assert length(shops) == 2
  end

  test "skips rows with incomplete data" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Shop B", "3.0", "4.0"],
      ["Incomplete", "4.2"],
      ["Also Incomplete"]
    ]

    {status, shops} = DataParser.parse(rows)

    assert status == :ok
    assert length(shops) == 2
  end

  test "skip rows with extra data" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Shop B", "3.0", "4.0"],
      ["Extra", "4.2", "5.3", "potato"]
    ]

    {status, shops} = DataParser.parse(rows)

    assert status == :ok
    assert length(shops) == 2
  end

  test "deduplicates shops" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Shop A", "1.0", "2.0"],
      ["Shop B", "3.0", "4.0"]
    ]

    {status, shops} = DataParser.parse(rows)

    assert status == :ok
    assert length(shops) == 2
  end

  test "not enough data entries" do
    rows = [
      ["Shop A", "1.0", "2.0"]
    ]

    {status, shops} = DataParser.parse(rows)

    assert status == :error
    assert shops == :not_enough_rows
  end
end
