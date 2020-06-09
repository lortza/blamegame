# Starter App

[![CircleCI](https://circleci.com/gh/lortza/starter_app.svg?style=svg)](https://circleci.com/gh/lortza/starter_app)

[![Maintainability](https://api.codeclimate.com/v1/badges/5900dd05417f73a806a7/maintainability)](https://codeclimate.com/github/lortza/starter_app/maintainability)

Description TBD

Live on heroku as TBD

## To Do
- [ ] Rename all the things in all of the files
- [ ] Set up routes
- [ ] Set up database
- [ ] Set up circleci
- [ ] Set up dependabot
- [ ] Set up codeclimate

## Features

* wip

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
