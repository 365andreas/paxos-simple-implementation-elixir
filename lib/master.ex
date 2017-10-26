defmodule Master do

  import IO

  def main([a, p | _]) do
    master(String.to_integer(a), String.to_integer(p))
  end

  # function showing PID of process logging a message
  def say(msg) do
    puts Kernel.inspect(self()) <> " " <> msg
  end

  def master(n, m) do

    # spawn counter
    counterPid = spawn(Counter, :count, [0])
    # :timer.sleep(1000)

    # spawn n consumers
    for _ <- 1..n do spawn(Consumer, :consume, [m, counterPid, self()]) end

    for _ <- 1..n do
      receive do
        {:done, senderPid} -> say "master  : :done received from " <> Kernel.inspect(senderPid)
                        #  _ -> puts "Something else but :done came"
        after
            180_000 -> say "master : Didn't receive all :done messages for 180s"
      end
    end

    # terminate counter
    Process.exit(counterPid, :kill)
  end
end
