defmodule CoffeeShopFinder.HTTPClient.Req do
  @moduledoc """
  An HTTP client implementation using the Req library.
  """
  @behaviour CoffeeShopFinder.HTTPClient

  def get(url) do
    Req.get(url)
  end
end
