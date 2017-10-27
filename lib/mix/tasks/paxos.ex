defmodule Mix.Tasks.Paxos do

  use Mix.Task

  def run([a, p |_]) do

    Master.master(String.to_integer(a), String.to_integer(p))
  end
end