defmodule PfmPhoenixWeb.UserAdmin do
  import Plug.Conn
  import Phoenix.Controller

  def ensure_user_is_admin(conn, _opts) do
    user = conn.assigns[:current_user]

    if user && user.role == "admin" do
      conn
    else
      conn
      |> put_flash(:error, "You don't have permissions to access this page.")
      |> redirect(to: "/users/log_in")
      |> halt()
    end
  end

  def on_mount(:ensure_admin, _params, _session, socket) do
    user = socket.assigns[:current_user]

    if user.role == :admin do
      {:cont, socket}
    else
      socket =
        socket
        |> Phoenix.LiveView.put_flash(
          :error,
          "You don't have permissions to access this page."
        )
        |> Phoenix.LiveView.redirect(to: "/users/log_in")

      {:halt, socket}
    end
  end
end
