defmodule ParticleBundleSupervisor do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_bundle(particles) do
    spec = %{
      id: ParticleBundle,
      start: {ParticleBundle, :start_link, [particles]},
      restart: :temporary
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
