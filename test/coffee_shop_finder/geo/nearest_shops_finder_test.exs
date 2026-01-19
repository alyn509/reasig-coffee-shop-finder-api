defmodule CoffeeShopFinder.NearestShopsFinderTest do
  use ExUnit.Case, async: true

  alias CoffeeShopFinder.Geo.NearestShopsFinder

  test "returns 3 nearest shops sorted by distance" do
    shops = [
      %{name: "A", x: 0.0, y: 0.0},
      %{name: "B", x: 10.0, y: 0.0},
      %{name: "C", x: 1.0, y: 1.0},
      %{name: "D", x: 2.0, y: 2.0}
    ]

    result = NearestShopsFinder.find(shops, 0.0, 0.0)

    assert Enum.map(result, & &1.name) == ["A", "C", "D"]
  end

  test "returns nearest shops on a set smaller than requested" do
    shops = [
      %{name: "A", x: 0.0, y: 0.0},
      %{name: "B", x: 10.0, y: 0.0}
    ]

    result = NearestShopsFinder.find(shops, 0.0, 0.0)

    assert Enum.map(result, & &1.name) == ["A", "B"]
  end
end
