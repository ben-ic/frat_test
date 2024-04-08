defmodule FratTestV2Web.InvoiceLive.Show do
  use FratTestV2Web, :live_view

  alias FratTestV2.Money

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"uuid" => uuid} = params, _, socket) do
    IO.inspect params
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:invoice, Money.get_invoice_by_uuid!(uuid))}
  end

  defp page_title(:show), do: "Show Invoice"
  defp page_title(:edit), do: "Edit Invoice"
end
