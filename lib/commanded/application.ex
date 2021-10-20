defmodule SkynetPhoenix.Commanded.Application do
  use Commanded.Application,
    otp_app: :skynet_phoenix,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: SkynetPhoenix.Commanded.EventStore
    ],
    pubsub: :local,
    registry: :local

  router(SkynetPhoenix.Commanded.Router)

  def init(config) do
    {:ok, config}
  end
end
