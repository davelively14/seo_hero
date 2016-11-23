defmodule SeoHero.ResultsController do
  use SeoHero.Web, :controller
  alias SeoHero.{Result, ResultCollection, Server}

  def index(conn, _params) do
    collections =
      ResultCollection
      |> order_by(desc: :inserted_at)
      |> Repo.all
      |> Repo.preload(:results)
    render conn, "index.html", collections: collections
  end
end
