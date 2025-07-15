# This module contains all particle computations

defmodule Particle do

  def init() do
    states = [1,0.8375,675] # initial state estimates
    weight = 1 # intial weight

    %{
      state: states,
      weight: weight
    }

  end

  def predict(%{state: [n,c,trx],weight: weight}) do # state transition function
    rho = 0
    beta = 0.0067
    lambda_u = 0.1
    lambda = 0.08
    p0 = 42.0e9
    m = 2215
    cp = 42.0e6/17
    mdotp = 340
    tp = 650

    n2 = n + (n*(rho-beta)/lambda_u + lambda*c ) + 0.01*:rand.normal(0,1)
    c2= c + (n*beta/lambda_u - lambda*c) + 0.01*:rand.normal(0,1);
    trx2 = trx + (p0*n/(m*cp) - 2*mdotp/m*(trx - tp)) + :rand.normal(0,1);

    %{
      state: [n2,c2,trx2],
      weight: weight
    }

  end

  def update(particle,measurement) do # state update function

    error = Enum.zip_with(particle.state, measurement, fn s, m -> s - m end)
    squared_errors = Enum.map(error, fn e -> e*e end)
    error_sum = Enum.sum(squared_errors)
    likelihood = :math.exp(-error_sum)


    %{
      state: particle.state,
      weight: likelihood
     }

  end


end
