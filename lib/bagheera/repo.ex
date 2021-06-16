defmodule Bagheera.Repo do
  use Ecto.Repo,
    otp_app: :bagheera,
    adapter: Ecto.Adapters.Postgres
end
