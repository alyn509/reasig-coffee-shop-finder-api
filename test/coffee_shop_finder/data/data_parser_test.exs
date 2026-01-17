defmodule CoffeeShopFinder.DataParserTest do
  use ExUnit.Case, async: true

  alias CoffeeShopFinder.Data.DataParser

  test "parses valid rows" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Shop B", "3.0", "4.0"]
    ]

    shops = DataParser.parse(rows)

    assert length(shops) == 2
    assert Enum.any?(shops, &(&1.name == "Shop A"))
  end

  test "skips malformed rows" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Broken", "abc", "xyz"]
    ]

    shops = DataParser.parse(rows)
    assert length(shops) == 1
  end

  test "deduplicates shops" do
    rows = [
      ["Shop A", "1.0", "2.0"],
      ["Shop A", "1.0", "2.0"]
    ]

    shops = DataParser.parse(rows)
    assert length(shops) == 1
  end
end
