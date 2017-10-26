defmodule Master do

  import IO

  def main([a, p | _]) do
    master(String.to_integer(a), String.to_integer(p))
  end

  # function showing PID of process logging a message
  def say(msg) do
    puts "#{Kernel.inspect(self())} " <> msg
  end

  def acceptorSay(msg) do
    puts "#{Kernel.inspect(self())} : acceptor : " <> msg
  end


  def master(a, p) do

    # spawn a consumers
    for _ <- 1..a do spawn(Consumer, :consume, [p, self(), self()]) end

    for _ <- 1..a do
      receive do
        {:done, senderPid} -> say "master  : :done received from " <> Kernel.inspect(senderPid)
                        #  _ -> puts "Something else but :done came"
        after
            180_000 -> say "master : Didn't receive all :done messages for 180s"
      end
    end

  end
end
