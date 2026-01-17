defmodule CoffeeShopFinder.CoordinateValidatorTest do
  use ExUnit.Case, async: true

  alias CoffeeShopFinder.Geo.CoordinateValidator

  test "valid coordinates pass" do
    assert CoordinateValidator.parse(47.6)
    assert CoordinateValidator.parse(-122.4)
  end

  test "invalid coordinates fail" do
    assert {:error, :out_of_range} = CoordinateValidator.parse(200)
    assert {:error, :out_of_range} = CoordinateValidator.parse(-200)
  end
end
