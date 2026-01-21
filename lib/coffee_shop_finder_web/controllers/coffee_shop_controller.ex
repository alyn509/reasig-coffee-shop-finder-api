defmodule CoffeeShopFinderWeb.CoffeeShopController do
  use CoffeeShopFinderWeb, :controller

  alias CoffeeShopFinder.{Data.DataStore, Geo.NearestShopsFinder, Geo.CoordinateValidator}

  @doc """
  Returns nearest coffee shops to the given coordinates.
  Expects query params `x` and `y`.
  """
  def nearest(conn, params) do
    with {:parse, {:ok, x, y}} <- {:parse, parse_coords(params)},
         {:fetch, {:ok, shops}} <- {:fetch, DataStore.all()} do
      json(conn, %{shops: NearestShopsFinder.find(shops, x, y)})
    else
      {:parse, {:error, :missing_params}} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Missing required query parameters: x and y"})

      {:parse, {:error, :invalid_coords}} ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Coordinates are invalid or out of range"})

      {:fetch, {:error, reason}} ->
        conn
        |> put_status(:service_unavailable)
        |> json(%{error: reason})

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid coordinates"})
    end
  end

  # Private helpers

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
