defmodule FratTestV2.Money.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  schema "invoices" do
    field :status, Ecto.Enum, values: [sent: 1, paid: 2, withdrawn: 3]
    field :description, :string
    field :amount, :float
    field :payor_email, :string
    belongs_to :user, FratTestV2.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:amount, :description, :status, :payor_email])
    |> validate_required([:amount, :description, :status, :payor_email])
  end
end
