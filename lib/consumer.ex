defmodule Consumer do

  import Master

  def consume(0, _, masterPid) do

    selfPid = self()
    send(masterPid, {:done, selfPid})
    # Process.exit(selfPid, :normal)
  end

  def consume(n, counterPid, masterPid) do

    say ("consumer : cnt=" <> to_string(n))
    send(counterPid, {:inc, self()})
    say ("consumer : sent inc message to " <> Kernel.inspect(counterPid))
    receive do
      {:report, state} -> say "counter : received : report " <> to_string(state);
                          :timer.sleep(2000);
                          consume(n-1, counterPid, masterPid)
    end
  end
end