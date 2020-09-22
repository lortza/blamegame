import consumer from "./consumer"

// Multi-channel version:
document.addEventListener('turbolinks:load', function () {
  const roundIdDiv = document.querySelector('#round-channel-id')
  let roundId = null
  if (roundIdDiv) {
    roundId = roundIdDiv.dataset.roundId
  }

  consumer.subscriptions.create({
      // This hash provides the params to the round_channel.rb
      channel: "RoundChannel",
      round_id: roundId
    }, {

      connected() {
        // Called when the subscription is ready for use on the server
        console.log('RoundChannel: Connected')
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log('RoundChannel: Disconnected')
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        const waiting = document.querySelector("#round-waiting");
        const results = document.querySelector("#round-results");
        const submissions = document.querySelector("#round-submissions");
        const winner = document.querySelector("#round-winner");

        console.log('Received:')

        console.log(`round_complete?: ${data.round_complete}`)
        console.log(`winner: ${data.winner}`)
        console.log(`results_by_candidate: ${data.results_by_candidate}`)

        if (data.round_complete == true){
          waiting.classList.add('hidden')
          results.classList.remove('hidden')
          winner.innerText = data.winner
        }

        if (data.candidate_name === undefined) {
          console.log('something undefined')
        } else {
          const submission = `<strong>${data.candidate_name}</strong> received a vote from ${data.voter_name}`;
          console.log(submission)
          submissions.insertAdjacentHTML('beforeend', '<li> ' + submission + '</li>')
        }
      }
    })
  })
