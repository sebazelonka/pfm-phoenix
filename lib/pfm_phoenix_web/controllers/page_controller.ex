defmodule PfmPhoenixWeb.PageController do
  use PfmPhoenixWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
