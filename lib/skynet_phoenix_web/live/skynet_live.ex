defmodule SkynetPhoenixWeb.SkynetLive do
  use SkynetPhoenixWeb, :live_view

  # alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket),
      do: Phoenix.PubSub.subscribe(SkynetPhoenix.PubSub, "terminators_update")

    {:ok, fetch(socket)}
  end

  @impl true
  def handle_event("killTerminator", %{"terminator" => terminator}, socket) do
    terminator
    |> pid_from_string()
    |> Skynet.kill_terminator()

    {:noreply, fetch(socket)}
  end

  def handle_event("spawnTerminator", _value, socket) do
    {:ok, pid} = Skynet.spawn_terminator()
    {:noreply, assign(socket, terminators: [pid | socket.assigns.terminators])}
  end

  @impl true
  def handle_info({:kill_terminator, _pid}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_info({:spawn_terminator, _pid}, socket) do
    {:noreply, fetch(socket)}
  end

  def fetch(socket) do
    assign(socket, terminators: Skynet.list_terminators())
  end

  def pid_from_string("#PID" <> string) do
    string
    |> :erlang.binary_to_list()
    |> :erlang.list_to_pid()
  end
end
