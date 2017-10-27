defmodule Proposer do

  import Master

  def receivePromises(0, list) , do: list
  def receivePromises(n, list) when n>0 do
    receive do
      {:promiseOk, tStore, cmd, pid} ->
        receivePromises(n-1, [{tStore, cmd, pid} |list])
    after
      # wait for 1s
      1_000 ->
        receivePromises(n-1, list)
    end
  end

  def receiveProposals(0, acc) , do: acc
  def receiveProposals(n, acc\\0) when n>0 do
    receive do
      :proposalSuccess ->
        # proposerSay "Received 'ProposalSuccess'"
        receiveProposals(n-1, acc+1)
    after
      # wait for 1s
      1_000 ->
        # proposerSay "Proposal didn't come"
        receiveProposals(n-1, acc)
    end
  end


  def propose(serverPids, cmd \\ -1, t \\ 0) do
    proposerSay "Starting..."
    # IO.puts "serverPids: #{Kernel.inspect serverPids}, cmd: #{cmd}, t: #{t}"

    # sleep for 100ms - 2s
    delay = Enum.random(100..2_000)
    :timer.sleep(delay)
    t=t+1

    # Phase 1
    # send Prepare message
    for pid <- serverPids do
      send(pid, {:prepare, t, self()})
    end

    a = length serverPids
    # wait for asnwers
    promises = receivePromises(a,[])
    # IO.puts Kernel.inspect(promises)
    if length(promises) <= a / 2 do
      propose(serverPids, cmd, t)
    end

    # Phase 2
    # IO.puts "Phase 2"
    {tStore,c ,_} = Enum.max_by(promises, &elem(&1, 1))
    # send Propose message
    if tStore > 0, do: cmd = c
    for {_ , _, pid} <- promises, do: send(pid, {:propose, t, cmd, self()})
    #wait for answers
    proposalsSuccess = receiveProposals(a)

    # Phase 3
    if proposalsSuccess <= a / 2 do
      propose(serverPids, cmd, t)
    end
    # send Prepare message
    for pid <- serverPids do
      send(pid, {:execute, cmd})
    end
  end

end