import consumer from "./consumer"

// Multi-channel version:
document.addEventListener('turbolinks:load', function () {

  consumer.subscriptions.create({
      // This hash provides the params to the round_channel.rb
      channel: "RoundChannel",
      round_id: document.querySelector('#round-channel-id').dataset.roundId
    }, {

      connected() {
        // Called when the subscription is ready for use on the server
        console.log('RoundChannel: Connected')
        console.log(data)
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

        const submission = `${data.candidate_name} received a vote from ${data.voter_name}`;
        console.log(submission)
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
          submissions.insertAdjacentHTML('beforeend', '<li> ' + submission + '</li>')
        }
      }
    })
  })
