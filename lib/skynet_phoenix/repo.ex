defmodule SkynetPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :skynet_phoenix,
    adapter: Ecto.Adapters.Postgres
end
