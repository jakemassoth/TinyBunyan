defmodule TinyBunyan.Repo do
  use Ecto.Repo,
    otp_app: :tiny_bunyan,
    adapter: Ecto.Adapters.Postgres
end
