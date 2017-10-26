defmodule Acceptor do

  import Master

  def serve(masterPid, tMax \\ 0, cmd \\ -1, tStore \\ 0) do

    # IO.puts "T_max: #{tMax}, cmd: #{cmd}, T_store: #{tStore}"

    receive do
      {:prepare, t, proposerPid} ->
        if t > tMax do
          send(proposerPid, {:promiseOk,tStore,cmd,self()} )
          serve(masterPid, t, cmd, tStore )
        end
      {:propose, t, cmdNew, proposerPid} ->
        if t == tMax do
          send(proposerPid, :proposalSuccess)
          serve(masterPid, tMax, cmdNew, t)
        end
      {:execcute, cmdExec} ->
          acceptorSay "Received 'Execute #{cmdExec}'"
          send(masterPid, {:executed, cmdExec})
    end
  end
end