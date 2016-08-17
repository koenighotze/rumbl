defmodule UserTest do
  use Rumbl.ModelCase, async: true
  import ExUnit.CaptureIO
  alias Rumbl.User

  @valid %{name: "foo", username: "foobar", password: "12345678"}

  test "User implements to_string" do
    assert capture_io(fn ->
      IO.puts %User{username: "foo"}
    end) =~ "foo"
  end

  test "valid changeset" do
    cs = User.changeset(%User{}, @valid)

    assert cs.valid?
  end

  test "empty user is invalid" do
    cs = User.changeset(%User{}, %{})

    refute cs.valid?
  end

  test "username must be less than 21 chars long" do
    cs = User.changeset(%User{}, %{@valid | username: String.duplicate("x", 21)})

    assert {:username, {"should be at most %{count} character(s)", [count: 20]}} in cs.errors
  end

  test "username must be less than 21 chars long / alternative syntax" do
    assert {:username, {"should be at most %{count} character(s)", [count: 20]}} in errors_on(%User{}, %{@valid | username: String.duplicate("x", 21)})
  end
end
