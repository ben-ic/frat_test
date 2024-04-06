defmodule FratTestV2.MoneyTest do
  use FratTestV2.DataCase

  alias FratTestV2.Money

  describe "invoices" do
    alias FratTestV2.Money.Invoice

    import FratTestV2.MoneyFixtures

    @invalid_attrs %{status: nil, description: nil, amount: nil, payor_email: nil}

    test "list_invoices/0 returns all invoices" do
      invoice = invoice_fixture()
      assert Money.list_invoices() == [invoice]
    end

    test "get_invoice!/1 returns the invoice with given id" do
      invoice = invoice_fixture()
      assert Money.get_invoice!(invoice.id) == invoice
    end

    test "create_invoice/1 with valid data creates a invoice" do
      valid_attrs = %{status: 42, description: "some description", amount: 120.5, payor_email: "some payor_email"}

      assert {:ok, %Invoice{} = invoice} = Money.create_invoice(valid_attrs)
      assert invoice.status == 42
      assert invoice.description == "some description"
      assert invoice.amount == 120.5
      assert invoice.payor_email == "some payor_email"
    end

    test "create_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Money.create_invoice(@invalid_attrs)
    end

    test "update_invoice/2 with valid data updates the invoice" do
      invoice = invoice_fixture()
      update_attrs = %{status: 43, description: "some updated description", amount: 456.7, payor_email: "some updated payor_email"}

      assert {:ok, %Invoice{} = invoice} = Money.update_invoice(invoice, update_attrs)
      assert invoice.status == 43
      assert invoice.description == "some updated description"
      assert invoice.amount == 456.7
      assert invoice.payor_email == "some updated payor_email"
    end

    test "update_invoice/2 with invalid data returns error changeset" do
      invoice = invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Money.update_invoice(invoice, @invalid_attrs)
      assert invoice == Money.get_invoice!(invoice.id)
    end

    test "delete_invoice/1 deletes the invoice" do
      invoice = invoice_fixture()
      assert {:ok, %Invoice{}} = Money.delete_invoice(invoice)
      assert_raise Ecto.NoResultsError, fn -> Money.get_invoice!(invoice.id) end
    end

    test "change_invoice/1 returns a invoice changeset" do
      invoice = invoice_fixture()
      assert %Ecto.Changeset{} = Money.change_invoice(invoice)
    end
  end
end
