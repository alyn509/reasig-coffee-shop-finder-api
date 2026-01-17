defmodule CoffeeShopFinderWeb.CoffeeShopController do
  use CoffeeShopFinderWeb, :controller

  alias CoffeeShopFinder.{Data.DataStore, Geo.NearestShopsFinder, Geo.CoordinateValidator}

  def nearest(conn, %{"x" => x, "y" => y}) do
    with {:ok, x} <- CoordinateValidator.parse(x),
         {:ok, y} <- CoordinateValidator.parse(y) do
      shops = DataStore.all()

      result =
        shops
        |> NearestShopsFinder.find(x, y)

      json(conn, %{results: result})
    else
      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{error: "Invalid coordinates"})
    end
  end
end
