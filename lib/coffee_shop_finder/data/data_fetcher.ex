defmodule CoffeeShopFinder.Data.DataFetcher do
  @moduledoc """
  Fetches the coffee shops CSV from the configured remote URL.
  """

  require Logger

  # Resolve the HTTP client at runtime so tests can swap it via config
  defp http_client do
    Application.get_env(:coffee_shop_finder, :req_module) ||
      Application.get_env(:coffee_shop_finder, :http_client) ||
      CoffeeShopFinder.HTTPClient.Req
  end

  def fetch_csv do
    url = Application.get_env(:coffee_shop_finder, :coffee_shops_csv_url)

    case http_client().get(url) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
