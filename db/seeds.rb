# frozen_string_literal: true

puts '**** Running seeds...'

puts 'Destroying AllTheThings!TM'
User.destroy_all
Category.destroy_all
PostType.destroy_all
Post.destroy_all

# user = User.find_by(email: 'admin@email.com')
user = User.create!(
        email: 'admin@email.com',
        password: 'password',
        password_confirmation: 'password',
        admin: true
      )
puts "Users: #{User.count}"

# Post Types
user.post_types.find_or_create_by!(name: 'TIL')
user.post_types.find_or_create_by!(name: 'Merit')
user.post_types.find_or_create_by!(name: 'Praise')
user.post_types.find_or_create_by!(name: 'Gratitude')
puts "PostTypes: #{user.post_types.count}"

# Categories
user.post_types.find_or_create_by!(name: 'Citizenship')
user.post_types.find_or_create_by!(name: 'Leadership')
user.post_types.find_or_create_by!(name: 'Skills & Competencies')
puts "Categories: #{user.categories.count}"

# Posts
10.times do
  Post.create!({
    post_type_id: user.post_types.sample.id,
    bookmarked: [true, false, false].sample,
    date: Faker::Date.between(from: 30.days.ago, to: Time.zone.today),
    url: ['', '', '', Faker::Internet.url].sample,
    with_people: ['', Faker::Name.first_name].sample,
    description: [Faker::Lorem.paragraph(sentence_count: 10), Faker::Markdown.block_code].sample
  })
end
puts "Posts: #{user.posts.count}"
