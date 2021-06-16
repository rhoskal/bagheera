# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :bagheera,
  ecto_repos: [Bagheera.Repo]

# Configures the endpoint
config :bagheera, BagheeraWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "R62zwPEjXg6Z9GVbKz++puuMvqAZPPvj0m7RAU39gI69TfZj2zBlGusF0zyVKQ8P",
  render_errors: [view: BagheeraWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Bagheera.PubSub,
  live_view: [signing_salt: "TmsCvFQX"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
