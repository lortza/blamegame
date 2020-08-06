import consumer from "./consumer"

consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Connected')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Disconnected')

  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('Received:')
    console.log(data.content)
    const messages = document.querySelector("#messages");
    messages.insertAdjacentHTML('beforeend', '<div class="message"> ' + data.content + '</div>')
  }
});

// Separate JS that logs entries
// document.addEventListener("turbolinks:load", function() {
//   submitMessages()
// })
//
// function submitMessages() {
//   const inputField = document.querySelector("#input");
//   const form = document.querySelector("#new_message");
//
//   form.addEventListener('submit', function () {
//     console.log(`gimmmmmme: ${inputField.value}`)
//     // inputField.value = null;
//     // event.preventDefault()
//   })
// }
