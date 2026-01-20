defmodule CoffeeShopFinderWeb.CoffeeShopController do
  use CoffeeShopFinderWeb, :controller

  alias CoffeeShopFinder.{Data.DataStore, Geo.NearestShopsFinder, Geo.CoordinateValidator}

  @doc """
  Returns nearest coffee shops to the given coordinates.
  Expects query params `x` and `y`.
  """
  def nearest(conn, params) do
    case parse_coords(params) do
      {:ok, x, y} ->
        run_nearest(conn, x, y)

      {:error, :missing_params} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Missing required query parameters: x and y"})

      {:error, :invalid_coords} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Coordinates are invalid or out of range"})
    end
  end

  # Private helpers

  defp run_nearest(conn, x, y) do
    case DataStore.all() do
      {:ok, data} ->
        shops = NearestShopsFinder.find(data, x, y)
        json(conn, %{shops: shops})

      {:error, reason} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: reason})
    end
  end

  defp parse_coords(%{"x" => x, "y" => y}) do
    with {:ok, x_val} <- CoordinateValidator.parse(x),
         {:ok, y_val} <- CoordinateValidator.parse(y) do
      {:ok, x_val, y_val}
    else
      _ -> {:error, :invalid_coords}
    end
  end

  defp parse_coords(_), do: {:error, :missing_params}
end
