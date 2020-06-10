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
puts "Users: #{User.count}"

game = user.games.create!

questions = [
  { family_friendly: true, text: "Who would you hire to plan your best friend's wedding?" },
  { family_friendly: true, text: "Who always ends up tripping their partner on the dance floor?" },
  { family_friendly: true, text: "Who can solve a Rubik's Cube the fastest?" },
  { family_friendly: false, text: "Who has played the game Twister naked?" },
  { family_friendly: false, text: "Who drinks whiskey in their coffee at work?" },
  { family_friendly: true, text: "Who has thrown a birthday party for their pet?" },
  { family_friendly: true, text: "Who doesn't need to use the instructions when putting together IKEA furniture?" },
]
questions.each do |question|
  next if Question.exists?(text: question[:text])
  Question.create!(question)
end
