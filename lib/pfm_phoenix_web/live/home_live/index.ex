defmodule PfmPhoenixWeb.HomeLive.Index do
  use PfmPhoenixWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      home
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_user: nil)}
  end
end
