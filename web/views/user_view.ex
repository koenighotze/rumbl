defmodule Rumbl.UserView do
  use Rumbl.Web, :view


  def first_name(%Rumbl.User{name: user}) do
    user
    |> String.split(" ")
    |> Enum.at(0)
  end
end
