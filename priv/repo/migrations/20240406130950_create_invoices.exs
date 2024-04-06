defmodule FratTestV2.Repo.Migrations.CreateInvoices do
  use Ecto.Migration

  def change do
    create table(:invoices) do
      add :amount, :float
      add :description, :string
      add :status, :integer
      add :payor_email, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:invoices, [:user_id])
  end
end
