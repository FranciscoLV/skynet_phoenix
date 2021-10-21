defmodule SkynetPhoenix.Commanded.Events.SpawnedTerminator do
  @derive Jason.Encoder
  defstruct [:pid]
end
