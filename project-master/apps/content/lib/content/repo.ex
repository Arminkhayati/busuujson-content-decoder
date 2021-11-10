defmodule Content.Repo do
  @moduledoc """
    Database adapter module.
  """
  use Ecto.Repo,
    otp_app: :content,
    adapter: Ecto.Adapters.Postgres
end
