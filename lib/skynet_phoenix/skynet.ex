defmodule Skynet do
  # Automatically defines child_spec/1
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl DynamicSupervisor
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def spawn_terminator() do
    child_spec = %{
      id: Skynet.Terminator,
      start: {Skynet.Terminator, :spawn, [state: 1]}
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  def kill_terminator(id) do
    DynamicSupervisor.terminate_child(__MODULE__, id)
  end

  def list_terminators() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.map(fn x -> Phoenix.HTML.Safe.to_iodata(elem(x, 1)) end)
  end

  defimpl Phoenix.HTML.Safe, for: PID do
    def to_iodata(pid), do: Kernel.inspect(pid)
  end
end
