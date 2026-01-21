defmodule CoffeeShopFinder.HTTPClient do
  @moduledoc """
  Behaviour defining an HTTP client.
  """
  @callback get(String.t()) :: {:ok, any()} | {:error, any()}
end
