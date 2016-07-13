defmodule Rumbl.CheckLogin do
  import Plug.Conn
  import Phoenix.Controller
  import Rumbl.Router.Helpers

  def init(_opts) do
  end

  def call(conn, _repo) do
      case conn.assigns.current_user do
        nil -> conn
               |> put_flash(:error, "Please log in first")
               |> redirect(to: page_path(conn, :index))
               |> halt()
        _ -> conn
      end
  end
end
