defmodule SkynetPhoenixWeb.SkynetLive do
  use SkynetPhoenixWeb, :live_view
  alias Phoenix.PubSub

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: PubSub.subscribe(SkynetPhoenix.PubSub, "termiantors_update")
    {:ok, fetch(socket)}
  end

  @impl true
  def handle_event("killTerminator", %{"terminator" => terminator}, socket) do
    terminator
    |> IO.inspect()
    |> pid_from_string()
    |> IO.inspect()
    |> Skynet.kill_terminator()
    |> IO.inspect()

    {:noreply, fetch(socket)}
  end

  def fetch(socket) do
    # IO.inspect(Skynet.list_terminators())
    assign(socket, terminators: Skynet.list_terminators())
  end

  defp pid_from_string("#PID" <> string) do
    string
    |> :erlang.binary_to_list()
    |> :erlang.list_to_pid()
  end
end
