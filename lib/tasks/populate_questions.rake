require 'csv'

namespace :db do
  desc "Populate Question Data"

  task :populate_questions, [:qty_records_to_seed] => [:environment] do |_t, args|
    # bundle exec rake db:populate_questions
    ActiveRecord::Migration.say_with_time('Populating question data') do
      source_file = Rails.root.join('lib', 'tasks', 'data', 'questions.csv')
      qty_all_records = source_file.readlines.size
      qty_to_populate = args[:qty_records_to_seed].presence || qty_all_records

      CSV.foreach(source_file, headers: true).take(qty_to_populate).each do |row|
        question = Question.where(text: row['text']).first_or_create!(row.to_h)
        puts question.text
      end
      Question.count
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
