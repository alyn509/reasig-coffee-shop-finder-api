defmodule CoffeeShopFinder.Data.DataParser do
  alias CoffeeShopFinder.Geo.CoordinateValidator

  def parse(rows) when is_list(rows) do
    rows
    |> Enum.reduce({MapSet.new(), []}, &dedupe_and_parse/2)
    |> elem(1)
    |> Enum.reverse()
  end

  defp dedupe_and_parse(row, {seen, acc}) do
    case parse_row(row) do
      {:ok, shop} ->
        key = {shop.name, shop.x, shop.y}

        if MapSet.member?(seen, key) do
          {seen, acc}
        else
          {MapSet.put(seen, key), [shop | acc]}
        end

      {:error, _} ->
        {seen, acc}
    end
  end

  defp parse_row([name, x, y]) do
    with {:ok, x} <- CoordinateValidator.parse(x),
         {:ok, y} <- CoordinateValidator.parse(y) do
      {:ok, %{name: name, x: x, y: y}}
    else
      _ -> {:error, :invalid_row}
    end
  end

  defp parse_row(_), do: {:error, :invalid_format}
end
