import Player from "./player"

let Beard = {
    init(socket, elem) {
        if (!elem) {
            return
        }

        let playerId = elem.getAttribute("data-player-id")
        let beardId = elem.getAttribute("data-id")

        socket.connect()

        Player.init(elem.id, playerId, () => {
            this.onReady(beardId, socket)
        })
    },
    onReady(beardId, socket) {
        let msgContainer = document.getElementById("msg-container")
        let msgInput = document.getElementById("msg-input")
        let postButton = document.getElementById("msg-submit")
        let vidChannel = socket.channel("beards:" + beardId)

        vidChannel.on("Pa...ping", ({count}) => console.log(`Ping with count ${count}`))
        vidChannel.on("new_annotation", resp => this.renderAnnotation(msgContainer, resp))
        vidChannel.join()
                  .receive("ok", resp => console.log("Nice, joined the channel", resp))
                  .receive("error", reason => console.log("Boom, could not join", reason))
        postButton.addEventListener("click", e => this.pushAnnotation(e, msgInput, vidChannel)); // this correct?
    },
    pushAnnotation(event, msgInput, vidChannel) {
        console.log("Pushing annotation to server")
        let payload = {
            body: msgInput.value,
            at: Player.getCurrentTime()
        }
        vidChannel.push("new_annotation", payload)
                  .receive("error", e => console.log(e))
    },
    receiveNewAnnotation(msgContainer, resp) {
        this.renderAnnotation(msgContainer, resp)
    },
    renderAnnotation(msgContainer, {user, body, at}) {
        console.log(`Rendering new annotation from user ${user}, "${body}", at ${at}`)
        let template = document.createElement("div")

        template.innerHTML = `
            <a href="#" data-seek="${at}">
                <b>${user.username}</b>: ${this.esc(body)}
            </a>
        `
        msgContainer.appendChild(template)
        msgContainer.scrollTop = msgContainer.scrollHeight
    },
    esc(body) {
        let div = document.createElement("div")
        div.appendChild(document.createTextNode(body))
        return div.innerHTML
    }
}

export default Beard