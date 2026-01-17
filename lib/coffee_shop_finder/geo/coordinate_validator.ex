defmodule CoffeeShopFinder.Geo.CoordinateValidator do
  @moduledoc """
  Validates coordinates.
  """
  @min -180
  @max 180

  def parse(value) when is_binary(value) do
    case Float.parse(value) do
      {num, ""} -> validate(num)
      _ -> {:error, :invalid_float}
    end
  end

  def parse(value) when is_number(value) do
    validate(value)
  end

  defp validate(value) when value >= @min and value <= @max do
    {:ok, value}
  end

  defp validate(_), do: {:error, :out_of_range}
end
