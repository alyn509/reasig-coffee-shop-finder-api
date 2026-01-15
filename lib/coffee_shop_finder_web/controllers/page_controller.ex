defmodule CoffeeShopFinderWeb.PageController do
  use CoffeeShopFinderWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
