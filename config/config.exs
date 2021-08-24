# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :skynet_phoenix,
  ecto_repos: [SkynetPhoenix.Repo]

# Configures the endpoint
config :skynet_phoenix, SkynetPhoenixWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QjtogW32g57CT1yVBZl1tNdwejYK4SS5QDf3RDU399/GhdiNrTJSuzGrFlRsIsO8",
  render_errors: [view: SkynetPhoenixWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: SkynetPhoenix.PubSub,
  live_view: [signing_salt: "E9nvZAT5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
