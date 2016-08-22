defmodule Rumbl.WatchViewTest do
  use Rumbl.ConnCase, async: true

  import Rumbl.WatchView, only: [player_id: 1]

  alias Rumbl.Beard

  test "player_id returns empty if url is missing" do
      id =
        %Beard{}
        |> player_id

      assert id == ""
  end

  test "player_id returns empty if url is nil" do
      id =
        %Beard{url: nil}
        |> player_id

      assert id == ""
  end

  test "player_id returns empty if url cannot be parsed" do
      id =
        %Beard{url: "ads"}
        |> player_id

      assert id == ""
  end

  test "player_id returns empty if url is neither http nor https" do
      id =
        %Beard{url: "udp://youtu.be/zjK0-TWdZxQ"}
        |> player_id

      assert id == ""
  end

  test "player_id returns the youtube-id if url can be parsed" do
      id =
        %Beard{url: "http://youtu.be/zjK0-TWdZxQ"}
        |> player_id

      assert "zjK0-TWdZxQ" == id
  end

  test "player_id returns the youtube-id if https is used" do
      id =
        %Beard{url: "https://youtu.be/zjK0-TWdZxQ"}
        |> player_id

      assert "zjK0-TWdZxQ" == id
  end
end
