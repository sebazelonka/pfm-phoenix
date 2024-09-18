defmodule PfmPhoenixWeb.UserController do
  use PfmPhoenixWeb, :controller
  alias PfmPhoenix.Users

  def index(conn, _params) do
    users = Users.list_users()
    render(conn, :index, users: users)
  end
end
