defmodule SeoHero.Server do
  use GenServer
  alias SeoHero.Results

  @default_time 2 * 60 * 60 * 1_000

  #######
  # API #
  #######

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  #############
  # Callbacks #
  #############

  # On start, will fetch data from Google and store it in the Repo
  # TODO do we want the server to maintain state or repo?
  def init(state) do
    Results.fetch_data
    schedule_fetch

    {:ok, state}
  end

  # When we receive :fetch, we will fetch_data and then reschedule fetch again
  def handle_info(:fetch, state) do
    Results.fetch_data
    schedule_fetch

    {:noreply, state}
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
end
