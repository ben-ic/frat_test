defmodule FratTestV2.Repo do
  use Ecto.Repo,
    otp_app: :frat_test_v2,
    adapter: Ecto.Adapters.Postgres
end
