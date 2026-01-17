defmodule CoffeeShopFinder.Geo.DistanceCalculator do
  def euclidean(x1, y1, x2, y2)
      when is_number(x1) and is_number(y1) and
             is_number(x2) and is_number(y2) do
    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
  end
end
