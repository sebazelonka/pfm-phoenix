defmodule PfmPhoenix.Repo do
  use Ecto.Repo,
    otp_app: :pfm_phoenix,
    adapter: Ecto.Adapters.Postgres
end
