defmodule Rumbl.WatchView do
  use Rumbl.Web, :view

  alias Rumbl.Beard

  def player_id(%Beard{url: url}) do
    cond do
      url == "abc"-> "foo"
      true -> ""
    end
    # TODO HIER GEHTS WEITER
    # ~r{}
    # |> Regex.named_captures(beard.url)
    # |> get_in(["url"])
  end
end
#
