

submission form new
show round.question
dropdown for nominee game.players
dropdown for nominator game.players


workflow 1
new game form
enter players
create new game & players
kicks off creation of all rounds, each with a question assigned



workflow two
moderator (admin? person who is signed in) creates a new game which generates....
- a game code
- a set of rounds each with a question
moderator sends link to all players: /games/ABCD/players/new
players each enter their name
submit redirects to a game/players/index page that says "hold tight"
when all players are in, the moderator clicks a boolean that says the game is ready
players refresh their page and see a button that says "go to round 1"
on this page games/ABCD/rounds/1/submission/new
shows the question
dropdown for nominee (game.players.map(&:name))
dropdown for nominator (later we'll use localstorage for this)
submit takes them to a "hold tight" page...?
if round.submissions.count == game.players.count
show button link to round show page
round show page has results & winner
submissions count for each player. player with most == winner
round stores player id as winner
if current round number < Game::DEFAULT_MAX_ROUNDS
button to go to next round (game.round.next?)
if current round number == Game::DEFAULT_MAX_ROUNDS
button to go to game show page with final stats & winner
game show page tallies all rounds' winners groupby count to get overall winner
