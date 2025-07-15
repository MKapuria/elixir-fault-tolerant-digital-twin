defmodule ParticleFilter do
  use Agent  # Stores current bundle PIDs for access and fault injection

  def start_link(plant_pid, num_particles \\ 1000) do
    {:ok, _} = ParticleBundleSupervisor.start_link(:ok)

    all_particles = init(num_particles)
    bundles = Enum.chunk_every(all_particles, div(num_particles, 5))

    bundle_pids =
      Enum.map(bundles, fn bundle ->
        {:ok, pid} = ParticleBundleSupervisor.start_bundle(bundle)
        pid
      end)

    # Store bundle PIDs for later access or manual killing
    Agent.start_link(fn -> bundle_pids end, name: __MODULE__)

    spawn_link(fn -> loop(plant_pid) end)
  end

  def loop(plant_pid) do
    send(plant_pid, {:get_measurement, self()})

    receive do
      {:measurement, measurement} ->
        # Always fetch the latest bundle list from the Agent
        bundle_pids = Agent.get(__MODULE__, & &1)

        # Filter out any that may have died
        alive_bundles = Enum.filter(bundle_pids, &Process.alive?/1)

        # Perform particle updates
        Enum.each(alive_bundles, fn pid ->
          ParticleBundle.update(pid, measurement)
        end)

        # Collect estimates
        estimates =
          Enum.map(alive_bundles, fn pid ->
            ParticleBundle.get_estimate(pid)
          end)

        # Combine into a single average
        estimate = average_estimates(estimates)

        CsvLogger.log("filter", estimate)

        # Recurse
        loop(plant_pid)
    end
  end

  defp average_estimates(estimates) do
    n = length(estimates)

    Enum.reduce(estimates, [0.0, 0.0, 0.0], fn [a, b, c], [acc_a, acc_b, acc_c] ->
      [acc_a + a / n, acc_b + b / n, acc_c + c / n]
    end)
  end

  def init(num_particles) do
    Enum.map(1..num_particles, fn _ -> Particle.init() end)
  end

  # Get the list of currently tracked bundle PIDs
  def bundles(), do: Agent.get(__MODULE__, & &1)

  # Kill a bundle at a given index, and remove it from Agent tracking
  def kill_bundle(index) do
    Agent.get_and_update(__MODULE__, fn pids ->
      case Enum.split(pids, index) do
        {keep, [pid | rest]} ->
          Process.exit(pid, :kill)
          IO.puts("Manually killed bundle at index #{index}, pid #{inspect(pid)}")
          {:ok, keep ++ rest}

        _ ->
          IO.puts("Invalid index #{index}")
          {:error, pids}
      end
    end)
  end
end
