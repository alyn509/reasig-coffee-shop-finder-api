defmodule CoffeeShopFinder.Geo.NearestShopsFinder do
  @moduledoc """
  Finds the nearest coffee shops to a given coordinate.
  """
  alias CoffeeShopFinder.Geo.DistanceCalculator

  def find(shops, user_x, user_y, k \\ 3) do
    Enum.reduce(shops, [], fn shop, acc ->
      distance =
        DistanceCalculator.euclidean(user_x, user_y, shop.x, shop.y)
        |> Float.round(4)

      shop = Map.put(shop, :distance, distance)

      insert_sorted(acc, shop, k)
    end)
  end

  defp insert_sorted(acc, shop, k) do
    acc
    |> insert(shop)
    |> Enum.take(k)
  end

  defp insert([], shop), do: [shop]

  defp insert([h | t] = acc, shop) do
    if shop.distance < h.distance do
      [shop | acc]
    else
      [h | insert(t, shop)]
    end
  end
end
