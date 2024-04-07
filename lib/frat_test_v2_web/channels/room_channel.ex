defmodule FratTestV2Web.RoomChannel do
  use FratTestV2Web, :channel
  alias FratTestV2.{Accounts, Money}

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def join("room:" <> private_room_id, payload, socket) do
    if authorized?(payload) do
      IO.inspect("joined" <> private_room_id)

      socket =
        socket
        |> assign(:room_id, private_room_id)

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("new_msg", %{"body" => "invoices"}, socket) do
    {:ok, email} = Base.decode64(socket.assigns[:room_id])
    user = Accounts.get_user_by_email(email)
    invoices = Money.list_invoices(user)
    broadcast!(socket, "new_msg", %{from: "#{email}", body: "invoices"})

    message = Enum.reduce(invoices, "", fn
      invoice, acc ->
        acc <> "<b>Invoice Number: #{invoice.id}</b><br/>
                Amount: #{invoice.amount}<br/>
                Payor: #{invoice.payor_email}<br/>
                Status: #{invoice.status}<br/><br/>"
    end)
    |> IO.inspect

    broadcast!(socket, "new_msg", %{from: "Tabbit", body: message})

    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast!(socket, "new_msg", %{
      from: "Tabbit",
      body: "Hi, I am not very smart.  If you want to see your invoices, write in 'invoices'"
    })

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
