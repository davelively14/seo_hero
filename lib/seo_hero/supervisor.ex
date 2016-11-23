defmodule SeoHero.Supervisor do
  use Supervisor
  alias SeoHero.Results

  @default_time 2 * 60 * 60 * 1_000

  #######
  # API #
  #######

  def start_link do
    Supervisor.start_link(__MODULE__, %{})
  end

  #############
  # Callbacks #
  #############

  # On start, will fetch data from Google and store it in the Repo
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

  #####################
  # Private Functions #
  #####################

  # Sends self a message :fetch after specified or default amount of time
  defp schedule_fetch(time \\ @default_time) do
    Process.send_after(self, :fetch, time)
  end
end
