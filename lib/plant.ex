# This is a simulation of the real system, to sample noisy measurements and send to the particle module

defmodule Plant do

  def start_link do
    initial_state = [1,0.8375,675]
    initial_meas = measure(initial_state)
    spawn_link(fn -> loop(initial_state, initial_meas) end)

  end

  def loop(state, last_meas) do
    receive do
      {:get_measurement, from_pid} ->
        send(from_pid, {:measurement, last_meas})
        loop(state, last_meas)

      :tick ->
        new_state = step(state)
        new_meas = measure(new_state)
        CsvLogger.log("plant", new_state)
        loop(new_state, new_meas)
    end
  end


  def initial_state() do
    [1,0.8375,675] # initial states

  end

  def step(initial_state) do # PKEs with process noise
    rho = 0
    beta = 0.0067
    lambda_u = 0.1
    lambda = 0.08
    p0 = 42.0e9
    m = 2215
    cp = 42.0e6/17
    mdotp = 340
    tp = 650
    delta_t = 0.1 #100 millisecond

    n2 = Enum.at(initial_state,0) + delta_t *(Enum.at(initial_state,0) * (rho - beta)/lambda_u + lambda*Enum.at(initial_state,1)) + 0.005*:rand.normal(0,1)
    c2 = Enum.at(initial_state,1) + delta_t * (Enum.at(initial_state,0) * beta/lambda_u - lambda*Enum.at(initial_state,1)) + 0.005* :rand.normal(0,1)
    trx2 = Enum.at(initial_state,2) + delta_t * ( p0*Enum.at(initial_state,0) / (m*cp) - 2*mdotp/m *(Enum.at(initial_state,2) - tp)) + 0.1*:rand.normal(0,1)

    [n2,c2,trx2]

  end

  def measure([n,c,trx]) do # Add measurement noise to states
    n_meas = n + :rand.normal(0,0.2)
    c_meas = c + :rand.normal(0,0.2)
    trx_meas = trx + :rand.normal(0,0.2)

    [n_meas, c_meas, trx_meas]

  end

end
