# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# config :gen_tcp_accept_and_close, port: 4000

# config :content, Content.Repo,
#   adapter: Ecto.Adapters.Postgres,
#   url: System.get_env("DATABASE_URL"),
#   ssl: true,
#   pool_size: 2 # Free tier db only allows 4 connections. Rolling deploys need pool_size*(n+1) connections.


##########################################################
config :content, Content.Repo,
  database: "content_repo",
  username: "armin",
  password: "1234",
  hostname: "localhost"


config :content,
        ecto_repos: [Content.Repo]
config :content,
  uploads_directory: "uploads"








# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :content, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:content, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
