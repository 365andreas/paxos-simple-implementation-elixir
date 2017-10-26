defmodule Counter do

  import Master

  def count(n) do

    state = n+1
    receive do
      {:inc, pid} -> say "counter  : received inc message, has state:" <> to_string(state)
                       <> "\n\t\t and will send report message to " <> Kernel.inspect(pid);
                     send(pid, {:report, state})
    end

    count(state)
  end

end