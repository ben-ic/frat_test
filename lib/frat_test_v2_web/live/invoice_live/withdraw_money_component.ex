defmodule FratTestV2Web.InvoiceLive.WithdrawMoneyComponent do
  use FratTestV2Web, :live_component

  alias FratTestV2.Money

  def handle_event("withdraw", _params, socket) do
    withdraw_money(socket.assigns.current_user)

    {:noreply,
     socket
     |> put_flash(:info, "Money withdrawn to your bank account")
     |> push_patch(to: socket.assigns.patch)}
  end

  def handle_event("cancel", _params, socket) do
    IO.inspect("here")

    {:noreply,
     socket
     |> push_patch(to: socket.assigns.patch)}
  end

  defp withdraw_money(user) do
    Money.withdraw_invoices(user)
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= if @paid_invoices > 0  do %>
        <div class="hero">
          Are you sure you want to withdraw $<%= @paid_invoices %> to your personal bank account
        </div>
        <div class="modal-action">
          <button for="my-modal-5" class="btn btn-success" phx-click="withdraw" phx-target={@myself}>
            Yes
          </button>
          <button for="my-modal-5" class="btn btn-cancel" phx-click="cancel" phx-target={@myself}>
            No
          </button>
        </div>
      <% else %>
        <div class="hero">You have no money in your account to withdraw</div>
        <button for="my-modal-5" class="btn btn-cancel" phx-click="cancel" phx-target={@myself}>
          Okay
        </button>
      <% end %>
    </div>
    """
  end
end
