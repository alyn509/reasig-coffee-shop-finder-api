defmodule CoffeeShopFinder.Data.DataStore do
  use GenServer

  require Logger

  alias CoffeeShopFinder.Data.{DataFetcher, DataParser}

  @refresh_interval :timer.minutes(10)

  # Public API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def all do
    GenServer.call(__MODULE__, :all)
  end

  def refresh do
    GenServer.cast(__MODULE__, :refresh)
  end

  # GenServer callbacks

  @impl true
  def init(_) do
    # Load initial shops safely
    state = load_shops()
    schedule_refresh()
    {:ok, state}
  end

  @impl true
  def handle_call(:all, _from, state) do
    {:reply, state.shops, state}
  end

  @impl true
  def handle_cast(:refresh, state) do
    new_state =
      case load_shops() do
        # successful load
        %{shops: shops} = s when shops != [] -> s
        # keep old data if refresh fails
        _ -> state
      end

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:refresh, state) do
    handle_cast(:refresh, state)
    schedule_refresh()
    {:noreply, state}
  end

  # Private helpers

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp load_shops do
    case DataFetcher.fetch_csv() do
      {:ok, rows} ->
        shops = DataParser.parse(rows)
        %{shops: shops, last_updated_at: DateTime.utc_now()}

      {:error, reason} ->
        Logger.error("Failed to load shops: #{inspect(reason)}")
        %{shops: [], last_updated_at: nil}
    end
  end
end
