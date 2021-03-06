defmodule Rumbl.Web do
  def model do
    quote do
      use Ecto.Schema


        
      import Ecto.Changeset
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def controller do
    quote do
      use Phoenix.Controller

      alias Rumbl.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]

      import Rumbl.Router.Helpers
      import Rumbl.Gettext

      import Rumbl.Auth, only: [ authenticate_user: 2 ]
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Rumbl.Router.Helpers
      import Rumbl.ErrorHelpers
      import Rumbl.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Rumbl.Auth, only: [ authenticate_user: 2 ]
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Rumbl.Repo
      import Ecto
      import Ecto.Query, only: [from: 1, from: 2]
      import Rumbl.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
