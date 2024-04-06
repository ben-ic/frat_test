defmodule FratTestV2Web.InvoiceLiveTest do
  use FratTestV2Web.ConnCase

  import Phoenix.LiveViewTest
  import FratTestV2.MoneyFixtures

  @create_attrs %{status: 42, description: "some description", amount: 120.5, payor_email: "some payor_email"}
  @update_attrs %{status: 43, description: "some updated description", amount: 456.7, payor_email: "some updated payor_email"}
  @invalid_attrs %{status: nil, description: nil, amount: nil, payor_email: nil}

  defp create_invoice(_) do
    invoice = invoice_fixture()
    %{invoice: invoice}
  end

  describe "Index" do
    setup [:create_invoice]

    test "lists all invoices", %{conn: conn, invoice: invoice} do
      {:ok, _index_live, html} = live(conn, ~p"/invoices")

      assert html =~ "Listing Invoices"
      assert html =~ invoice.description
    end

    test "saves new invoice", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("a", "New Invoice") |> render_click() =~
               "New Invoice"

      assert_patch(index_live, ~p"/invoices/new")

      assert index_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invoice-form", invoice: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invoices")

      html = render(index_live)
      assert html =~ "Invoice created successfully"
      assert html =~ "some description"
    end

    test "updates invoice in listing", %{conn: conn, invoice: invoice} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("#invoices-#{invoice.id} a", "Edit") |> render_click() =~
               "Edit Invoice"

      assert_patch(index_live, ~p"/invoices/#{invoice}/edit")

      assert index_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#invoice-form", invoice: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/invoices")

      html = render(index_live)
      assert html =~ "Invoice updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes invoice in listing", %{conn: conn, invoice: invoice} do
      {:ok, index_live, _html} = live(conn, ~p"/invoices")

      assert index_live |> element("#invoices-#{invoice.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#invoices-#{invoice.id}")
    end
  end

  describe "Show" do
    setup [:create_invoice]

    test "displays invoice", %{conn: conn, invoice: invoice} do
      {:ok, _show_live, html} = live(conn, ~p"/invoices/#{invoice}")

      assert html =~ "Show Invoice"
      assert html =~ invoice.description
    end

    test "updates invoice within modal", %{conn: conn, invoice: invoice} do
      {:ok, show_live, _html} = live(conn, ~p"/invoices/#{invoice}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Invoice"

      assert_patch(show_live, ~p"/invoices/#{invoice}/show/edit")

      assert show_live
             |> form("#invoice-form", invoice: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#invoice-form", invoice: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/invoices/#{invoice}")

      html = render(show_live)
      assert html =~ "Invoice updated successfully"
      assert html =~ "some updated description"
    end
  end
end
