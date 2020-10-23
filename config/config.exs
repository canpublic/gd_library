# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :gd_library,
  namespace: GDLibrary,
  ecto_repos: [GDLibrary.Repo]

# Configures the endpoint
config :gd_library, GDLibraryWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "WOp7Jkn64r8WPmbESDe1GW+iuXwkhyrBSXcdn7D+DRxG5K2bfRHtnZGkpULElAlB",
  render_errors: [view: GDLibraryWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: GDLibrary.PubSub,
  live_view: [signing_salt: "GwIhk9KS"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
