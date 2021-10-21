defmodule SkynetPhoenixWeb.SkynetLive do
  use SkynetPhoenixWeb, :live_view

  # alias Phoenix.PubSub
  alias SkynetPhoenix.Commanded.Terminators.Commands.SpawnTerminator
  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket),
      do: Phoenix.PubSub.subscribe(SkynetPhoenix.PubSub, "terminators_update")

    socket = fetch(socket) |> assign(skynet_id: UUID.uuid1())
    {:ok, socket}
  end

  @impl true
  def handle_event("killTerminator", %{"terminator" => terminator}, socket) do
    terminator
    |> pid_from_string()
    |> Skynet.kill_terminator()

    {:noreply, fetch(socket)}
  end

  def handle_event("spawnTerminator", _value, socket) do
    # {:ok, pid} = C.SpawnTerminator
    :ok =
      SkynetPhoenix.Commanded.Application.dispatch(%SpawnTerminator{id: socket.assigns.skynet_id})

    {:noreply, assign(socket, terminators: [socket.assigns.terminators])}
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
