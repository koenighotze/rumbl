defmodule Rumbl.Auth do
  import Plug.Conn

  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller
  import Logger
  alias Rumbl.User
  alias Rumbl.Router.Helpers

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user]
           -> conn
      user = user_id && repo.get(User, user_id)
           -> assign(conn, :current_user, user)
      true -> assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    info("Logging out")
    configure_session(conn, drop: true)
  end

  def login_by_username_and_password(conn, name, passwd, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(Rumbl.User, username: name)

    cond do
      user && checkpw(passwd, user.password_hash)
           -> {:ok, login(conn, user)}
      user -> {:error, :unauthorized, conn}
      true -> dummy_checkpw()
              {:error, :not_found, conn}
    end
  end

  def authenticate_user(conn, _opts) do
    # Todo: think of a smarter way... maybe check for the key or something
    case conn.assigns.current_user do
      nil -> conn
             |> put_flash(:error, "Please log in first")
             |> redirect(to: Helpers.page_path(conn, :index))
             |> halt()
      _ -> conn
    end
  end
end
