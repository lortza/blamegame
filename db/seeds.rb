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

qty_to_seed = 20
Rake::Task['db:populate_official_deck1'].invoke(qty_to_seed)

player_names = %w[Albert Alex Ditter Ivy James Jasper LionelScritchy Loki LukeBrown Mindy Moonie Murph Pickles Thor Zorro]

3.times do
  game = user.games.create!(
    max_rounds: 5,
    adult_content_permitted: true
  )
  game.generate_rounds

  player_names.sample(5).each do |player_name|
    game.players.create!(name: player_name)
  end
end
