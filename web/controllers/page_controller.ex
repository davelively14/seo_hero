defmodule SeoHero.PageController do
  use SeoHero.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
