defmodule CoffeeShopFinder.DataFetcher do
  @moduledoc """
  Fetches the coffee shops CSV from the configured remote URL.
  """

  require Logger

  def fetch_csv do
    url = Application.get_env(:coffee_shop_finder, :coffee_shops_csv_url)

    if is_nil(url) do
      Logger.error("DataFetcher failed: CSV URL is not configured")
      raise "Application misconfigured: remote data source unavailable."
    end

    case Req.get(url) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: status}} ->
        Logger.error("CSV fetch failed with status #{status}")
        {:error, {:error, status}}

      {:error, reason} ->
        Logger.error("CSV fetch error: #{inspect(reason)}")
        {:error, {:error, reason}}
    end
  end
end
