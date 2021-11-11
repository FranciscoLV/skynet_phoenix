defmodule Skynet.Terminator do
  use GenServer

  @five_seconds 5000
  @ten_seconds 10000

  def start_link(opts \\ []) do
    application_name = Keyword.fetch!(opts, :name)
    name = {:via, Registry, {SkynetPhoenix.Terminator.Registry, application_name}}
    GenServer.start_link(SkynetPhoenix.Terminator.Registry, name)
  end

  @impl GenServer
  def init(_) do
    Process.send_after(self(), :respawn, @five_seconds)
    Process.send_after(self(), :sarahconnor, @ten_seconds)
    {:ok, nil}
  end

  def spawn(opts \\ []) do
    uuid = Keyword.fetch!(opts, :name)
    name = {:via, Registry, {SkynetPhoenix.Terminator.Registry, uuid}}
    GenServer.start_link(__MODULE__, nil, name: name)
  end

  @impl GenServer
  def handle_info(:respawn, state) do
    random_number = :rand.uniform(100)

    case random_number do
      random_number when random_number <= 20 ->
        Skynet.spawn_terminator()
        Process.send_after(self(), :respawn, @five_seconds)
        {:noreply, state}

      _ ->
        Process.send_after(self(), :respawn, @five_seconds)
        {:noreply, state}
    end
  end

  @impl GenServer
  def handle_info(:sarahconnor, state) do
    random_number = :rand.uniform(100)

    case random_number do
      random_number when random_number <= 25 ->
        Skynet.kill_terminator(self())
        {:noreply, state}

      _ ->
        Process.send_after(self(), :sarahconnor, @ten_seconds)
        {:noreply, state}
    end
  end

  defimpl Jason.Encoder, for: PID do
    def encode(pid, _), do: Kernel.to_string(pid)
  end

  def alive?(pid) do
    case Registry.lookup(SkynetPhoenix.Terminator.Registry, pid) do
      [] -> false
      [{_pid, _}] -> true
    end
  end
end
