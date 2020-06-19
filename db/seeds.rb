# frozen_string_literal: true

puts '**** Running seeds...'

puts 'Destroying AllTheThings!TM'
Submission.destroy_all
Round.destroy_all
Game.destroy_all
Player.destroy_all
Question.destroy_all
User.destroy_all

# user = User.find_by(email: 'admin@email.com')
user = User.create!(
        email: 'admin@email.com',
        password: 'password',
        password_confirmation: 'password',
        admin: true
      )
puts "User: #{User.count}"

qty_to_seed = 10
Rake::Task['db:populate_questions'].invoke(qty_to_seed)

game = user.games.create!
adult_content_permitted = true
game.generate_rounds

['Albert', 'Alex', 'Ivy', 'Zorro'].each do |player_name|
  game.players.create!(name: player_name)
end
