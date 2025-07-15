defmodule Main do
  def run do
    plant_pid = Plant.start_link()
    Clock.start_link(plant_pid)
    ParticleFilter.start_link(plant_pid, 1000)
  end
end
