defmodule Proposer do

  # import Master

  def propose(masterPid, tMax \\ 0, cmd \\ -1, tStore \\ 0) do

    IO.puts "T_max: #{tMax}, cmd: #{cmd}, T_store: #{tStore}"

    # sleep for 100ms - 2s
    delay = Enum.random(100..2_000)
    :timer.sleep(delay)


    # receive do
    #   {:inc, pid} -> IO.puts "counter  : received inc message, has state:" <> to_string(state)
    #                     <> "\n\t\t and will send report message to " <> Kernel.inspect(pid);
    #                   send(pid, {:report, state})
    # after
    #   5000 ->
    #     IO.puts :stderr, "No message in 5 seconds"
    # end

    propose(masterPid, tMax, cmd, tStore)
  end

end