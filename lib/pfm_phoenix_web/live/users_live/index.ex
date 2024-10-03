defmodule PfmPhoenixWeb.UsersLive.Index do
  use PfmPhoenixWeb, :live_view

  alias PfmPhoenix.Accounts

  on_mount {PfmPhoenixWeb.UserAuth, :ensure_authenticated}
  on_mount {PfmPhoenixWeb.UserAdmin, :ensure_admin}

  @impl true
  def mount(_params, _session, socket) do
    users = Accounts.list_users()

    {:ok,
     socket
     |> assign(:stream, %{users: users})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>Users</.header>
    <.table id="users" rows={@stream.users}>
      <:col :let={user} label="Email">
        <%= user.email %>
      </:col>
      <%!-- <:col :let={user} label="Name">
        <%= user.name %>
      </:col>--%>
      <:col :let={user} label="Role">
        <%= user.role %>
      </:col>
      <%!--<:col :let={user} label="Registered at">
        <%= user.inserted_at %>
      </:col> --%>
    </.table>
    """
  end
end
