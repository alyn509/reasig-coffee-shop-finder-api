defmodule CoffeeShopFinder.Data.DataStore do
  @moduledoc """
  In-memory store for coffee shop data and sets up a periodic refresh.
  """
  use GenServer

  require Logger

  alias CoffeeShopFinder.Data.{DataFetcher, DataParser}
  alias CoffeeShopFinder.Constants

  # Public API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def all do
    try do
      GenServer.call(__MODULE__, :all)
    catch
      :exit, {:noproc, _} ->
        {:error, :service_unavailable}
    end
  end

  # GenServer callbacks

  @impl true
  def init(_) do
    {:ok, %{shops: [], fetched_at: nil}}
  end

  @impl true
  def handle_call(:all, _from, state) do
    cond do
      cache_valid?(state) ->
        {:reply, {:ok, state.shops}, state}

      true ->
        case load_shops() do
          {:ok, new_state} ->
            {:reply, {:ok, new_state.shops}, new_state}

          {:error, reason} ->
            Logger.error("Cache refresh failed: #{inspect(reason)}")
            {:reply, {:error, :service_unavailable}, state}
        end
    end
  end

  @impl true
  def handle_cast(:refresh, state) do
    new_state =
      case load_shops() do
        # successful load
        {:ok, %{shops: shops} = s} when shops != [] -> s
        # keep old data if refresh fails
        _ -> state
      end

    {:noreply, new_state}
  end

  @impl true
  def handle_cast(:clear, _state) do
    # Reset to an empty, valid state for the store
    {:noreply, %{shops: [], fetched_at: nil}}
  end

  @impl true
  def handle_info(:refresh, state) do
    new_state =
      case load_shops() do
        {:ok, s} -> s
        _ -> state
      end

    {:noreply, new_state}
  end

  # Private helpers

  defp cache_valid?(%{fetched_at: nil}), do: false

  defp cache_valid?(%{fetched_at: fetched_at}) do
    DateTime.diff(DateTime.utc_now(), fetched_at) < Constants.ttl_seconds()
  end

  defp load_shops do
    with {:ok, body} <- DataFetcher.fetch_csv(),
         rows <- NimbleCSV.RFC4180.parse_string(body, skip_headers: true),
         {:ok, shops} <- DataParser.parse(rows) do
      {:ok,
       %{
         shops: shops,
         fetched_at: DateTime.utc_now()
       }}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
