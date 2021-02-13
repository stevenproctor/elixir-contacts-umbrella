# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :contact_web,
  generators: [context_app: false]

# Configures the endpoint
config :contact_web, ContactWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mlrCTvP8DwPO9srJT7/JhpA5YWGNiIf8Y4LS8IEqb1Npy1m6KQhXBqakLtrm/OR2",
  render_errors: [view: ContactWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ContactWeb.PubSub,
  live_view: [signing_salt: "QJvSPgdo"]

config :contact_web,
  generators: [context_app: :contact_web]

# Configures the endpoint
config :contact_web, ContactWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "YWVrtl3a6WJYZHlIP3LiBOiMY/puVteL7xIlcqHidumpZHDy53c2rqbHYbyBhfbO",
  render_errors: [view: ContactWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ContactWeb.PubSub,
  live_view: [signing_salt: "2lhP9nx7"]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
