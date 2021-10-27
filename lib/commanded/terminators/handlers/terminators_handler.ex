defmodule SkynetPhoenix.Commanded.Terminators.Handlers.TerminatorsHandler do
  @behaviour Commanded.Commands.Handler

  alias SkynetPhoenix.Commanded.Terminators.Aggregate, as: Terminator
  alias SkynetPhoenix.Commanded.Terminators.Commands, as: C
  alias SkynetPhoenix.Commanded.Events, as: E

  def handle(%Terminator{id: nil}, %C.SpawnTerminator{} = command) do
    {:ok, pid} = Skynet.spawn_terminator()
    initialize_event = %E.SkynetInitialize{id: command.id}
    spawned_terminator = %E.SpawnedTerminator{pid: pid}

    [initialize_event, spawned_terminator]
  end

  def handle(%Terminator{}, %C.SpawnTerminator{}) do
    {:ok, pid} = Skynet.spawn_terminator()
    spawned_terminator = %E.SpawnedTerminator{pid: pid}
    [spawned_terminator]
  end
end
