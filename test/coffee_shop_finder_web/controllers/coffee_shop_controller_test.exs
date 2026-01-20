defmodule CoffeeShopFinderWeb.CoffeeShopControllerTest do
  use CoffeeShopFinderWeb.ConnCase, async: true

  alias CoffeeShopFinder.Data.DataStore

  setup do
    # Ensure the DataStore has some shops for testing
    DataStore.all()
    :ok
  end

  test "GET /coffee_shops returns nearby shops", %{conn: conn} do
    conn =
      get(conn, "/api/coffee-shops/nearest", %{
        "y" => "-122.4",
        "x" => "47.6"
      })

    assert %{
             "shops" => [
               %{
                 "name" => "Starbucks Seattle2",
                 "x" => _,
                 "y" => _,
                 "distance" => _
               },
               %{
                 "name" => "Starbucks Seattle",
                 "x" => _,
                 "y" => _,
                 "distance" => _
               },
               %{
                 "name" => "Starbucks SF",
                 "x" => _,
                 "y" => _,
                 "distance" => _
               }
             ]
           } = json_response(conn, 200)
  end
end
