defmodule CoffeeShopFinder.Constants do
  @moduledoc """
  Application-wide constants.
  """

  # Minimum number of valid shops required to consider data load successful
  @min_no_of_valid_shops 2

  # Time-to-live for cached data in seconds (24 hours)
  @ttl_seconds 24 * 60 * 60

  # Coordinate limits
  @min_coordinate_limit -180
  @max_coordinate_limit 180

  def min_no_of_valid_shops, do: @min_no_of_valid_shops
  def ttl_seconds, do: @ttl_seconds
  def min_coordinate_limit, do: @min_coordinate_limit
  def max_coordinate_limit, do: @max_coordinate_limit
end
