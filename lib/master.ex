defmodule Master do

  import IO

  def main([a, p | _]) do
    master(String.to_integer(a), String.to_integer(p))
  end

  # function showing PID of process logging a message
  def masterSay(msg) do
    puts "#{Kernel.inspect(self())} : master   : " <> msg
  end

  def acceptorSay(msg) do
    puts "#{Kernel.inspect(self())} : acceptor : " <> msg
  end

  def proposerSay(msg) do
    puts "#{Kernel.inspect(self())} : proposer : " <> msg
  end

  def master(a, p) do

    # spawn a acceptors
    acceptorsPids = for _ <- 1..a, do: spawn(Acceptor, :serve, [self()])

    # IO.puts "acceptorsPids: #{Kernel.inspect acceptorsPids}"

    #spawn p proposers
    for c <- 1..p, do: spawn(Proposer, :propose, [acceptorsPids, c])

    for _ <- 1..a do
      receive do
        {:executed, _} -> nil
      end
    end
  end
end