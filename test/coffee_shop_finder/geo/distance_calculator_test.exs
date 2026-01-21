defmodule CoffeeShopFinder.DistanceCalculatorTest do
  use ExUnit.Case, async: true

  alias CoffeeShopFinder.Geo.DistanceCalculator

  test "distance between identical points is zero" do
    x1 = 42.0
    y1 = 42.0
    x2 = 42.0
    y2 = 42.0
    assert DistanceCalculator.euclidean(x1, y1, x2, y2) == 0.0
  end

  test "calculates euclidean distance correctly" do
    x1 = 0.0
    y1 = 0.0
    x2 = 3.0
    y2 = 4.0
    d = DistanceCalculator.euclidean(x1, y1, x2, y2)
    assert d == 5.0
  end
end
