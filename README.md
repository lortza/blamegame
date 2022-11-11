# BlameGame

[![CircleCI](https://circleci.com/gh/lortza/blamegame.svg?style=svg)](https://circleci.com/gh/lortza/blamegame)

[![Maintainability](https://api.codeclimate.com/v1/badges/639f9dda118f72314481/maintainability)](https://codeclimate.com/github/lortza/blamegame/maintainability)

The BlameGame is a Rails side project to make an online version of a card game where players vote for their teammate who is most likely to match the prompt. For example, which of your teammates is most likely to have been valedictorian in high school? I made it during the initial COVID-19 lockdown so my coworkers, friendds, and family I could still play games like this together remotely.

## See it Live
~Live on heroku as http://blamegame.herokuapp.com/~ The BlameGame was enjoyed while it lasted on the Heroku free tier. We'll find another home for it soon.


## Features
* an account-holding user can create new games, decide how many rounds to play, and choose whether to include adult content
* when a question pops up, all players vote for another player (or themselves)
* all players must submit an answer for gameplay to continue -- this prevents people from skirting the tricky questions and ends up making a lot of laughs
* players receive instant vote feedback via ActionCable
* all players' votes are tallied through the game so we can see a grand winner at the end
* uses some ridiculous css gradients and throwback scrolling marquee just for fun
* has a neon 80s vibe to it with the help of Bluma themes

## Getting Started

* Fork & Clone
* `bundle`
* Set up DB: `rake db:setup` (Runs `db:create`, `db:schema:load` and `db:seed`)
* User: In development, see the seeds file for the user credentials so you can log in
* `routes.rb`: comment out line 7, uncomment line 10 to allow users to sign up at http://localhost:3000/users/sign_up


## Tests
* Tests: `bundle exec rspec`

### Linters
This project uses these linters in CI:
* [reek](https://github.com/troessner/reek)
* [rubocop](https://github.com/rubocop-hq/rubocop)
* [scss-lint](https://github.com/sds/scss-lint)
* FactoryBot.lint -- coming soon

Run them locally on your machine like this:
```
bundle exec reek

bundle exec rubocop

bundle exec scss-lint app/assets/stylesheets/**.scss
```

## Related Docs
* [Devise](https://github.com/plataformatec/devise) user authentication (sign up/in/out)
* [Pundit](https://github.com/varvet/pundit) user authorization (restricts access to content)
* [Uglifier](https://github.com/lautis/uglifier) in harmony mode
* [Dependabot](https://app.dependabot.com/accounts/lortza/) dependency manager
* [Shoulda Matchers](https://github.com/thoughtbot/shoulda-matchers) for testing model relationships and validations
* [FactoryBot](https://github.com/thoughtbot/factory_bot/blob/master/GETTING_STARTED.md) to build test objects
