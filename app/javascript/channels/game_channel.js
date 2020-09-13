import consumer from "./consumer"

document.addEventListener('turbolinks:load', function () {
  const getCookie = function (name) {
  	var value = "; " + document.cookie;
  	var parts = value.split("; " + name + "=");
  	if (parts.length == 2) return parts.pop().split(";").shift();
  };

  consumer.subscriptions.create({
      // This hash provides the params to the game_channel.rb
      channel: 'GameChannel',
      game_id: getCookie('game_id')
    }, {

      connected() {
        // Called when the subscription is ready for use on the server
        console.log('GameChannel: Connected')
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log('GameChannel: Disconnected')
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log('Received:')
        const waitingTitle = document.querySelector("#game-waiting-for-players-title");
        const waitingSection = document.querySelector("#game-waiting-for-players-section");
        const players = document.querySelector("#game-players");
        const ready = document.querySelector("#game-ready");

        if (data.game_activated == true){
          ready.classList.remove('hidden')
          waitingTitle.remove()
          waitingSection.remove()
        }

        if (data.player_name === undefined || data.player_name === 'undefined') {
          console.log('player undefined')
        } else {
          players.insertAdjacentHTML('beforeend', `<p class='title is-4 mb-0'>${data.player_name}</p>`)
        }
      }
    })
  })
