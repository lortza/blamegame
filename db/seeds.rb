# frozen_string_literal: true

puts '**** Running seeds...'

puts 'Destroying AllTheThings!TM'
User.destroy_all
Question.destroy_all
Game.destroy_all

# user = User.find_by(email: 'admin@email.com')
user = User.create!(
        email: 'admin@email.com',
        password: 'password',
        password_confirmation: 'password',
        admin: true
      )
puts "User: #{User.count}"

questions = [
  { adult_rating: false, text: "Who would you hire to plan your best friend's wedding?" },
  { adult_rating: false, text: "Who always ends up tripping their partner on the dance floor?" },
  { adult_rating: false, text: "Who can solve a Rubik's Cube the fastest?" },
  { adult_rating: true, text: "Who has played the game Twister naked?" },
  { adult_rating: true, text: "Who drinks whiskey in their coffee at work?" },
  { adult_rating: false, text: "Who has thrown a birthday party for their pet?" },
  { adult_rating: false, text: "Who doesn't need to use the instructions when putting together IKEA furniture?" },
]
questions.each do |question|
  next if Question.exists?(text: question[:text])
  Question.create!(question)
end
puts "Question: #{Question.count}"

game = user.games.create!
adult_content_permitted = true
game.generate_rounds(adult_content_permitted)

['Albert', 'Alex', 'Ivy', 'Zorro'].each do |player_name|
  game.players.create!(name: player_name)
end
