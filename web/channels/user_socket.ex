defmodule Rumbl.UserSocket do
  use Phoenix.Socket
  import Logger

  @max_token_age 2 * 7 * 24 * 60 * 60 # two weeks in seconds
  @salt "user socket"

  ## Channels
  channel "beards:*", Rumbl.BeardChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    info("Connecting with token #{token}")

    case Phoenix.Token.verify(socket, @salt, token, max_age: @max_token_age) do
      {:ok, user_id}   -> {:ok, assign(socket, :user_id, user_id)}
      {:error, reason} -> warn("Cannot connect to channel beacause of #{reason}")
                          :error
    end
  end

  # if token is missing, we throw an error
  def connect(_params, _socket), do: :error

  def id(socket), do: "user_socket:#{socket.assigns[:user_id]}"
end
