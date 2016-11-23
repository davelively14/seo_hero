defmodule SeoHero.Supervisor do
  use Supervisor

  #######
  # API #
  #######

  def start_link do
    Supervisor.start_link(__MODULE__, %{})
  end

  #############
  # Callbacks #
  #############

  def init(_) do
    children = [
      worker(SeoHero.Server, [])
    ]

    options = [
      strategy: :one_for_one,
      shutdown: 7_000
    ]

    supervise(children, options)
  end
end
