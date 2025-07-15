# This is for logging data into a csv file so we can plot it in real time using python

defmodule CsvLogger do
  def log(source, [n, c, trx]) do
    timestamp = :os.system_time(:millisecond) / 1000
    line = "#{timestamp},#{source},#{n},#{c},#{trx}\n"
    File.write!("log.csv", line, [:append])
  end
end
