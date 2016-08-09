defmodule UserTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Rumbl.User

  test "User implements to_string" do
    assert capture_io(fn ->
      IO.puts %User{username: "foo"}
    end) =~ "foo"
  end

end
