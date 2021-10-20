defmodule SkynetPhoenix.Commanded.Router do
  use Commanded.Commands.Router

  alias SkynetPhoenix.Commanded.Terminators.Aggregate, as: Terminator
  alias SkynetPhoenix.Commanded.Terminators.Handlers, as: H
  alias SkynetPhoenix.Commanded.Terminators.Commands, as: C

  dispatch(C.SpawnTerminator, to: H.TerminatosHandler, aggregate: Terminator, identity: :id)
  dispatch(C.KillTerminator, to: H.TerminatosHandler, aggregate: Terminator, identity: :id)
end
