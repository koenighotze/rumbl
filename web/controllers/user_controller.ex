defmodule Rumbl.UserController do
  use Rumbl.Web, :controller

  import Logger

  def index(conn, _params) do
    users = Repo.all(Rumbl.User)

    info("users: #{inspect users}")
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(Rumbl.User, id)

    render conn, "show.html", user: user
  end
end
