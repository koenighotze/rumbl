defmodule Rumbl.UserView do
  use Rumbl.Web, :view

  def first_name(%Rumbl.User{name: user}) do
    extract(user)
  end

  defp extract(nil), do: ""

  defp extract(username) do
    username
    |> String.split(" ")
    |> Enum.at(0)
  end
end
