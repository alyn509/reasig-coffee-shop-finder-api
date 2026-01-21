defmodule CoffeeShopFinder.HTTPClient.Req do
  @behaviour CoffeeShopFinder.HTTPClient

  def get(url) do
    Req.get(url)
  end
end
