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

  def delete(conn, %{"id" => id}) do
    collection = ResultCollection |> Repo.get(id) |> Repo.preload(:results)

    collection.results
    |> Enum.each(&Repo.delete(&1))

    collection |> Repo.delete

    redirect(conn, to: results_path(conn, :index))
  end
end
