defmodule FratTestV2Web.InvoiceLive.Index do
  use FratTestV2Web, :live_view

  alias FratTestV2.Money
  alias FratTestV2.Money.Invoice

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :invoices, Money.list_invoices())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Invoice")
    |> assign(:invoice, Money.get_invoice!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Invoice")
    |> assign(:invoice, %Invoice{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Invoices")
    |> assign(:invoice, nil)
  end

  @impl true
  def handle_info({FratTestV2Web.InvoiceLive.FormComponent, {:saved, invoice}}, socket) do
    {:noreply, stream_insert(socket, :invoices, invoice)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    invoice = Money.get_invoice!(id)
    {:ok, _} = Money.delete_invoice(invoice)

    {:noreply, stream_delete(socket, :invoices, invoice)}
  end
end
