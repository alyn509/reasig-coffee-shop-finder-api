defmodule CoffeeShopFinder.Constants do
  # Minimum number of valid shops required to consider data load successful
  @min_no_of_valid_shops 2

  # Data fetch refresh interval
  @data_fetch_refresh_interval :timer.hours(24)

  # Coordinate limits
  @min_coordinate_limit -180
  @max_coordinate_limit 180

  def min_no_of_valid_shops, do: @min_no_of_valid_shops
  def refresh_interval, do: @data_fetch_refresh_interval
  def min_coordinate_limit, do: @min_coordinate_limit
  def max_coordinate_limit, do: @max_coordinate_limit
end
