defmodule SeoHero.PageController do
  use SeoHero.Web, :controller
  alias SeoHero.Server

  def index(conn, _params) do
    render conn, "index.html", collection: Server.get_state
  end
end
