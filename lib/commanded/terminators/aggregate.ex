defmodule SkynetPhoenix.Commanded.Terminators.Aggregate do
  alias SkynetPhoenix.Commanded.Events, as: E

  defstruct terminators: [],
            id: nil

  def apply(%__MODULE__{}, %E.SkynetInitialize{} = event) do
    %__MODULE__{id: event.id}
  end

  def apply(%__MODULE__{terminators: terminators}, %E.SpawnedTerminator{} = event) do
    IO.inspect("terminators:")
    IO.inspect(terminators)
    %__MODULE__{terminators: [event.pid | terminators]}
  end
end
