defmodule SeoHero.ValidateSupervisor do
  use Supervisor

  #######
  # API #
  #######

  def start_link(domain) do
    Supervisor.start_link(__MODULE__, [], name: :"ValidateSupervisor-#{domain}")
  end

  #############
  # Callbacks #
  #############

  def init(domain) do
    children = [
      worker(SeoHero.Validate, [], [restart: :transient])
    ]

    options = [
      strategy: :simple_one_for_one,
      max_restarts: 3,
      max_seconds: 3
    ]

    supervise(children, options)
  end
end
