defmodule Publicare.Repo do
  use Ecto.Repo,
    otp_app: :publicare,
    adapter: Ecto.Adapters.Postgres
end
