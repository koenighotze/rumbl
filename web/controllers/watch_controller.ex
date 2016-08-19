defmodule Rumbl.WatchController do
  use Rumbl.Web, :controller

  alias Rumbl.Beard

  def show(conn, %{"id" => id}) do
    beard = Repo.get!(Beard, id)

    render(conn, "index.html", beard: beard)
  end
end
