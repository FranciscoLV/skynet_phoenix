defmodule Skynet.Terminator do
  use GenServer

  @five_seconds 5000
  @ten_seconds 10000

  @impl GenServer
  def init(_) do
    Process.send_after(self(), :respawn, @five_seconds)
    Process.send_after(self(), :sarahconnor, @ten_seconds)
    {:ok, nil}
  end

  def spawn(_) do
    GenServer.start_link(__MODULE__, nil, [])
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
end
