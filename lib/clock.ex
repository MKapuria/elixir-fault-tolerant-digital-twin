# global clock

defmodule Clock do

  def start_link(target_pid) do
    spawn_link(fn -> loop(target_pid) end)
  end

  def loop(target_pid) do
    send(target_pid, :tick)
    Process.sleep(100) # send tick every 100 millisecond
    loop(target_pid)
  end

end
