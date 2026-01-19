defmodule CoffeeShopFinder.Geo.CoordinateValidator do
  @moduledoc """
  Validates coordinates.
  """

  alias CoffeeShopFinder.Constants

  def parse(value) when is_binary(value) do
    case Float.parse(value) do
      {num, ""} -> validate(num)
      _ -> {:error, :invalid_float}
    end
  end

  def parse(value) when is_number(value) do
    validate(value)
  end

  defp validate(value) do
    if value >= Constants.min_coordinate_limit() and
         value <= Constants.max_coordinate_limit() do
      {:ok, value}
    else
      {:error, :out_of_range}
    end
  end
end
