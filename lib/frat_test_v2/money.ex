defmodule FratTestV2.Money do
  @moduledoc """
  The Money context.
  """

  import Ecto.Query, warn: false
  alias FratTestV2.Repo

  alias FratTestV2.Money.Invoice

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices(user) do
    Invoice
    |> user_invoices_query(user.id)
    |> Repo.all()
  end

  def get_paid_invoices(user) do
    Repo.one(
      from i in Invoice,
        where: i.user_id == ^user.id and i.status == :paid,
        select: sum(i.amount),
        group_by: i.status
    )
  end

  def get_unpaid_invoices(user) do
    Repo.one(
      from i in Invoice,
        where: i.user_id == ^user.id and i.status == :sent,
        select: sum(i.amount),
        group_by: i.status
    )
  end

  def get_withdrawn_invoices(user) do
    Repo.one(
      from i in Invoice,
        where: i.user_id == ^user.id and i.status == :withdrawn,
        select: sum(i.amount),
        group_by: i.status
    )
  end

  def withdraw_invoices(user) do
    from(
      i in Invoice,
      where: i.user_id == ^user.id and i.status == :paid,
      update: [set: [status: :withdrawn]]
    )
    |> Repo.update_all([])
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(id), do: Repo.get!(Invoice, id)

  def get_invoice_by_uuid!(uuid), do: Repo.get_by!(Invoice, uuid: uuid)

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(%{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice(user, attrs \\ %{}) do

    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{data: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.changeset(invoice, attrs)
  end

  defp user_invoices_query(query, user_id) do
    from(v in query, where: v.user_id == ^user_id)
  end
end
