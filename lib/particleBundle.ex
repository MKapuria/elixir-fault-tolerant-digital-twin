defmodule ParticleBundle do
  use GenServer

  ## Public API

  def start_link(initial_particles) do
    GenServer.start_link(__MODULE__, initial_particles)
  end

  def update(pid, measurement) do
    GenServer.cast(pid, {:update, measurement})
  end

  def get_estimate(pid) do
    GenServer.call(pid, :get_estimate)
  end

  ## GenServer Callbacks

  def init(initial_particles) do
    {:ok, initial_particles}
  end

  def handle_cast({:update, measurement}, particles) do
    updated =
      particles
      |> Enum.map(&Particle.predict/1)
      |> Enum.map(&Particle.update(&1, measurement))

    {:noreply, updated}
  end

  def handle_call(:get_estimate, _from, particles) do
    estimate = compute_weighted_estimate(particles)
    {:reply, estimate, particles}
  end

  ## Internal

  defp compute_weighted_estimate(particles) do
    total_weight = Enum.reduce(particles, 0.0, fn p, acc -> acc + p.weight end)

    if total_weight == 0 do
      [0.0, 0.0, 0.0]
    else
      [n_sum, c_sum, trx_sum] =
        Enum.reduce(particles, [0.0, 0.0, 0.0], fn %{state: [n, c, trx], weight: w}, [ns, cs, ts] ->
          [ns + n * w, cs + c * w, ts + trx * w]
        end)

      [n_sum / total_weight, c_sum / total_weight, trx_sum / total_weight]
    end
  end
end
