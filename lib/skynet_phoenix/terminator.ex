defmodule Skynet.Terminator do
  use GenServer
  alias Phoenix.PubSub

  @five_seconds 5000
  @ten_seconds 10000
  # @pubsub_name SkynetPhoenix.PubSub
  # @pubsub_topic :terminators_update

  @impl GenServer
  def init(_) do
    Process.send_after(self(), :respawn, @five_seconds)
    # Process.send_after(self(), :sarahconnor, @ten_seconds)
    {:ok, nil}
  end

  def spawn(_) do
    GenServer.start_link(__MODULE__, nil, [])
  end

  @impl GenServer
  def handle_info(:respawn, state) do
    random_number = :rand.uniform(100)
    # IO.puts(random_number)

    case random_number do
      random_number when random_number <= 20 ->
        # IO.puts("New terminator has been spawn!")
        Skynet.spawn_terminator()
        # PubSub.broadcast(@pubsub_name, @pubsub_topic, Skynet.list_terminators())
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
        # IO.puts("Terminator has been killed!")
        Skynet.kill_terminator(self())
        # PubSub.broadcast(@pubsub_name, @pubsub_topic, Skynet.list_terminators())
        {:noreply, state}

      _ ->
        Process.send_after(self(), :sarahconnor, @ten_seconds)
        {:noreply, state}
    end
  end
end
