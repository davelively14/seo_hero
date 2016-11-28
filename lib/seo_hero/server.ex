defmodule SeoHero.Server do
  use GenServer
  import Ecto.Query, only: [from: 2]
  alias SeoHero.{Fido, ResultCollection, Result, Repo}

  # 2 hours
  # @default_time 2 * 60 * 60 * 1_000

  # 38 minutes
  @default_time 38 * 60 * 1_000

  # Default url list. Will ensure page one and two are returned in this ornder
  @default_urls [
    "https://www.google.com/search?q=seo+hero&near=new+york,new+york&aqs=chrome..69i57.2804j0j9&sourceid=chrome&ie=UTF-8#q=seo+hero&near=new+york,new+york",
    "https://www.google.com/search?q=seo+hero&near=new+york,new+york&aqs=chrome..69i57.2804j0j9&sourceid=chrome&ie=UTF-8#q=seo+hero&near=new+york,new+york&start=10"
  ]

  #######
  # API #
  #######

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  # Simply returns the stored state, which will be the most recent results
  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  #############
  # Callbacks #
  #############

  # On start, will fetch data from Google and store it in the Repo
  # TODO do we want the server to maintain state or repo?
  def init(_state) do
    new_state = get_data

    schedule_fetch

    {:ok, new_state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  # When the server receives a :fetch call, it will fetch_data, store it in the
  # repo, reschedule through schedule_fetch, and updated the state with the
  # newest results
  def handle_info(:fetch, _state) do
    new_state = get_data
    schedule_fetch

    {:noreply, new_state}
  end

  def handle_info(_, state) do
    {:noreply, state}
  end

  #####################
  # Private Functions #
  #####################

  # Sends self a message :fetch after specified or default amount of time
  defp schedule_fetch(time \\ @default_time) do
    Process.send_after(self, :fetch, time)
  end

  defp get_data do
    new_results = Fido.fetch_data
    {:ok, collection} = create_result_collection

    new_results
    |> Enum.each(&store_result(&1, collection))

    Repo.preload collection, results: from(r in Result, order_by: [asc: r.rank])
  end

  # Creates a new row in result_collection and returns that collection.
  defp create_result_collection do
    %ResultCollection{}
    |> ResultCollection.changeset
    |> Repo.insert
  end

  # Stores each result in the Repo and associates it with a ResultCollection
  defp store_result(result, collection) do
    collection
    |> Ecto.build_assoc(:results)
    |> Result.changeset(result)
    |> Repo.insert
  end
end
