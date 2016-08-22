defmodule Rumbl.WatchView do
  use Rumbl.Web, :view

  alias Rumbl.Beard

  def player_id(%Beard{url: nil}), do: ""

  def player_id(%Beard{url: url}) do
    # TODO: obviously use real pattern for url
    # this will only work for stuff like e.g. http://youtube.com/343423
    ~r{https?://.*/(?<id>.*)}
    |> Regex.named_captures(url)
    |> extract_id
  end

  defp extract_id(%{"id" => id}), do: id
  defp extract_id(_), do: ""
end
