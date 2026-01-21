defmodule CoffeeShopFinder.HTTPClient do
  @callback get(String.t()) :: {:ok, any()} | {:error, any()}
end
