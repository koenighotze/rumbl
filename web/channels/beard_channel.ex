defmodule Rumbl.BeardChannel do
    use Rumbl.Web, :channel
    import Logger

    def join("beards:" <> beard_id, _params, socket) do
        # :timer.send_interval(5_000, :ping) # sends a message, that must be handled using handle_info
        beard_id = String.to_integer(beard_id)
        beard = Repo.get!(Rumbl.Beard, beard_id)

        annotations =
            Repo.all(
                from a in assoc(beard, :annotations), order_by: [asc: a.at, asc: a.id], limit: 200, preload: [:user]
            )

        resp = %{annotations: Phoenix.View.render_many(annotations, Rumbl.AnnotationView, "annotation.json")}

        {:ok, resp, assign(socket, :beard_id, beard_id)}
    end

    def handle_in(event, params, socket) do
        # set by user socket
        user = Repo.get(Rumbl.User, socket.assigns.user_id)
        handle_in(event, params, user, socket)
    end

    def handle_in("new_annotation", %{"body" => body, "at" => at} = params, user, socket) do
        info("Received annotation '#{body}' at #{at}")

        changeset =
            user
            |> build_assoc(:annotations, beard_id: socket.assigns.beard_id)
            |> Rumbl.Annotation.changeset(params)

        case Repo.insert(changeset) do
            {:ok, annotation} -> broadcast! socket, "new_annotation", %{
                                       user: Rumbl.UserView.render("user.json", %{user: user}),
                                       body: body,
                                       at: at
                                 }
                                 {:reply, :ok, socket}
            {:error, changeset} -> {:reply, {:error, %{errors: changeset}}, socket}
        end
    end

    def handle_info(:ping, socket) do
        count = socket.assigns[:count] || 1

        push socket, "Pa...ping", %{count: count}

        {:noreply, assign(socket, :count, count + 1)}
    end
end