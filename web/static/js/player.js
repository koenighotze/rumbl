let Player = {
  init(domId, playerId, onReady) {
    window.onYouTubeIframeAPIReady = () => {
      console.log("Youtube IFrame ready...")
      this.onIframeReady(domId, playerId, onReady)
    }

    // todo load script asynchronously or with a timeout
    // let youtubeScriptTag = document.createElement("script")
    // youtubeScriptTag.src = "//www.youtube.com/iframe_api"
    // document.head.appendChild(youtubeScriptTag)
  },

  onIframeReady(domId, playerId, onReady) {
    console.log("onIframeReady...")

    this.player = new YT.Player(domId, {
      height: "360",
      width: "420",
      videoId: playerId,
      events: {
        "onReady": (event => onReady(event)),
        "onStateChange": (event => this.onPlayerStateChange(event))
      }
    })
  },

  onPlayerStateChange(event) {
    console.log("Player state change")
  },

  getCurrentTime() {
    return Math.floor(this.player.getCurrentTime() * 1000)
  },

  seekTo(millis) {
    return this.player.seekTo(millis/1000)
  }
}

export default Player
