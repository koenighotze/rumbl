defmodule Rumbl.BeardController do
  use Rumbl.Web, :controller

  alias Rumbl.Beard

  plug :scrub_params, "beard" when action in [:create, :update]


  def action(conn, _) do
    apply(__MODULE__, action_name(conn), [conn, conn.params, conn.assigns.current_user])
  end

  def user_beards(user) do
    assoc(user, :beards)
  end

  def index(conn, _params, user) do
    beards = Repo.all(user_beards(user))
    render(conn, "index.html", beards: beards)
  end

  def new(conn, _params, user) do
    changeset =
        user
        |> build_assoc(:beards)
        |> Beard.changeset

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"beard" => beard_params}, user) do
    changeset =   user
                  |> build_assoc(:beards)
                  |> Beard.changeset(beard_params)

    case Repo.insert(changeset) do
      {:ok, _beard} ->
        conn
        |> put_flash(:info, "Beard created successfully.")
        |> redirect(to: beard_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user) do
    beard = Repo.get!(user_beards(user), id)
    render(conn, "show.html", beard: beard)
  end

  def edit(conn, %{"id" => id}, user) do
    beard = Repo.get!(user_beards(user), id)
    changeset = Beard.changeset(beard)
    render(conn, "edit.html", beard: beard, changeset: changeset)
  end

  def update(conn, %{"id" => id, "beard" => beard_params}, user) do
    beard = Repo.get!(user_beards(user), id)
    changeset = Beard.changeset(beard, beard_params)

    case Repo.update(changeset) do
      {:ok, beard} ->
        conn
        |> put_flash(:info, "Beard updated successfully.")
        |> redirect(to: beard_path(conn, :show, beard))
      {:error, changeset} ->
        render(conn, "edit.html", beard: beard, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, user) do
    beard = Repo.get!(user_beards(user), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(beard)

    conn
    |> put_flash(:info, "Beard deleted successfully.")
    |> redirect(to: beard_path(conn, :index))
  end
end
