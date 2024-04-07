defmodule FratTestV2Web.UserRegistrationLive do
  use FratTestV2Web, :live_view

  alias FratTestV2.Accounts
  alias FratTestV2.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  @spec handle_event(<<_::32, _::_*32>>, map(), any()) :: {:noreply, any()}
  def handle_event("save", %{"user" => user_params}, socket) do

    if can_create(socket) do
      case Accounts.register_user(user_params) do
        {:ok, user} ->
          {:ok, _} =
            Accounts.deliver_user_confirmation_instructions(
              user,
              &url(~p"/users/confirm/#{&1}")
            )

          check_tracking_cookie_rate(socket.assigns.tracking_cookie, 1)
          check_ip_rate(socket.assigns.ip_address, 1)
          changeset = Accounts.change_user_registration(user)
          {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    else
      {:noreply, socket |> assign(trigger_submit: true)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end

  def can_create(socket) do

    with {:allow, count} <- check_tracking_cookie_rate(socket.assigns.tracking_cookie, 0),
         {:allow, count} <- check_ip_rate(socket.assigns.ip_address, 0) do
      true
    else
      {:deny, _count} -> false
    end
  end

  defp check_tracking_cookie_rate(tracking_cookie, inc) do
    case tracking_cookie do
      nil -> {:allow, 0}
      _cookie_id -> Hammer.check_rate_inc("tracking_cookie:#{tracking_cookie}", 300_000, 5, inc)
    end
  end

  defp check_ip_rate(ip_address, inc) do
    Hammer.check_rate_inc("tracking_ip:#{ip_address}", 600_000, 10, inc)
  end
end
