defmodule CoffeeShopFinderWeb.CoffeeShopControllerTest do
  use CoffeeShopFinderWeb.ConnCase, async: false

  import Mox

  setup :verify_on_exit!

  setup do
    csv_data = """
    name,x,y
    Starbucks Seattle2,47.5869,-122.3368
    Starbucks Seattle,47.5809,-122.316
    Starbucks SF,37.5209,-122.334
    """

    Mox.stub(CoffeeShopFinder.HTTPClientMock, :get, fn _url ->
      {:ok, %Req.Response{status: 200, body: csv_data}}
    end)

    {:ok, pid} = CoffeeShopFinder.Data.DataStore.start_link([])
    # allow the DataStore process to use the HTTPClientMock stubs defined in this test process
    Mox.allow(CoffeeShopFinder.HTTPClientMock, self(), pid)

    on_exit(fn ->
      if Process.whereis(CoffeeShopFinder.Data.DataStore) do
        GenServer.stop(CoffeeShopFinder.Data.DataStore)
      end
    end)

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

  test "GET /coffee_shops with service_unavailable", %{conn: conn} do
    # Simulate DataStore failure by stopping the GenServer
    :ok = GenServer.stop(CoffeeShopFinder.Data.DataStore)

    conn =
      get(conn, "/api/coffee-shops/nearest", %{
        "y" => "-122.4",
        "x" => "47.6"
      })

    assert %{"error" => _} = json_response(conn, 503)
  end
end
