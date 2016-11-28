defmodule Rumbl.BeardChannel do
    use Rumbl.Web, :channel
    import Logger

    def join("beards:" <> _beard_id, _params, socket) do
        # :timer.send_interval(5_000, :ping) # sends a message, that must be handled using handle_info
        {:ok, socket}
    end

    def handle_in("new_annotation", %{"body" => body, "at" => at}, socket) do
        info("Received annotation '#{body}' at #{at}")

        broadcast! socket, "new_annotation", %{
            user: %{username: "anonymous"},
            body: body,
            at: at
        }

        {:reply, :ok, socket}
    end

    def handle_info(:ping, socket) do
        count = socket.assigns[:count] || 1

        push socket, "Pa...ping", %{count: count}

        {:noreply, assign(socket, :count, count + 1)}
    end
end