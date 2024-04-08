defmodule FratTestV2.Repo.Migrations.AddBinaryKeyToInvoices do
  use Ecto.Migration

  def change do
    alter table("invoices") do
      add :uuid, :uuid
    end
  end
end
