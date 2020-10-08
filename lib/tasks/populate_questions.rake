require 'csv'

namespace :db do
  desc "Populate Official Deck 1 Questions"
  task :populate_official_deck1, [:qty_records_to_seed] => [:environment] do |_t, args|
    # bundle exec rake db:populate_official_deck1
    ActiveRecord::Migration.say_with_time('Populating question data') do
      source_file = Rails.root.join('lib', 'tasks', 'data', 'official_questions1.csv')
      qty_all_records = source_file.readlines.size
      qty_to_populate = args[:qty_records_to_seed].presence || qty_all_records
      game_owner = User.find_by(admin: true)
      deck = game_owner.decks.find_or_create_by(name: 'Official 1')

      CSV.foreach(source_file, headers: true).take(qty_to_populate).each do |row|
        deck.questions.where(text: row['text']).first_or_create!(row.to_h)
        print '.'
      end
      deck.questions.count
    end
  end

  desc "Populate Official Deck 2 Questions"
  task :populate_official_deck2, [:qty_records_to_seed] => [:environment] do |_t, args|
    # bundle exec rake db:populate_official_deck2
    ActiveRecord::Migration.say_with_time('Populating question data') do
      source_file = Rails.root.join('lib', 'tasks', 'data', 'official_questions2.csv')
      qty_all_records = source_file.readlines.size
      qty_to_populate = args[:qty_records_to_seed].presence || qty_all_records
      game_owner = User.find_by(admin: true)
      deck = game_owner.decks.find_or_create_by(name: 'Official 2')

      CSV.foreach(source_file, headers: true).take(qty_to_populate).each do |row|
        deck.questions.where(text: row['text']).first_or_create!(row.to_h)
        print '.'
      end
      deck.questions.count
    end
  end

  desc "Back-populate questions with decks"
  task :assign_deck_to_questions do
    # bundle exec rake db:assign_deck_to_questions
    game_owner = User.find_by(admin: true)
    default_deck_1 = game_owner.decks.create!(name: 'Official 1')
    game_owner.decks.create!(name: 'Official 2')

    Question.all.each do |question|
      question.update!(deck: default_deck_1)
    end
  end
end


# namespace :db do
#   namespace :populate do
#     desc 'Populate Caremark McKesson Program Medications'
#     task :caremark_mck_medications, [:qty_records_to_seed] => [:environment] do |_t, args|
#       # envoke with `bundle exec rake db:populate:caremark_mck_medications`
#       ActiveRecord::Migration.say_with_time('Seeding CaremarkMck Program Medications') do
#         source_file = Rails.root.join('lib', 'tasks', 'data', 'mckesson_caremark_gsns_round_1.csv')
#         qty_all_records = source_file.readlines.size
#         qty_to_populate = args[:qty_records_to_seed].presence || qty_all_records
#         program = Program.find_by(identifier: 'caremark_mck')
#
#         CSV.foreach(source_file, headers: true).take(qty_to_populate).each do |row|
#           next if program.program_medications.exists?(name: row[0], gsn: row[1])
#
#           program.program_medications.create(row.to_h)
#           print '.'
#         end
#         program.program_medications.count
#       end
#     end
#   end
# end
