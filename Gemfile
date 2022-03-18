source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.3'
gem 'bootsnap', '>= 1.4.2', require: false  # Reduces boot times through caching; required in config/boot.rb
gem 'sentry-raven'              # Error reporting in sentry
gem 'devise'                    # User authentication
gem 'jbuilder', '~> 2.7'        # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'pg', '>= 0.18', '< 2.0'    # Use postgresql as the database for Active Record
gem 'puma', '~> 5.6'            # Use Puma as the app server
gem 'pundit'                    # Authorization
gem 'rails-controller-testing'
gem 'sass-rails', '>= 6'        # Use SCSS for stylesheets
gem 'turbolinks', '~> 5'        # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'webpacker', '~> 4.0'       # Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'will_paginate', '~> 3.2.0' # pagination. Styles: http://mislav.github.io/will_paginate/
gem 'redis', '~> 4.0'           # Use Redis adapter to run Action Cable in production
# gem 'bcrypt', '~> 3.1.7'    # Use Active Model has_secure_password
# gem 'image_processing', '~> 1.2'  # Use Active Storage variant


group :development, :test do
  gem 'factory_bot_rails'       # factory support for rspec
  gem 'rspec-rails', '~> 4.0.1'
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]   # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'better_errors'           # creates console in browser for errors
  gem 'binding_of_caller'       # goes with better_errors
  gem 'bullet'                  # detects n+1 queries
  gem 'pry-rails'               # https://github.com/rweng/pry-rails
end

group :development do
  gem 'annotate' # adds attributes to top of models: https://github.com/ctran/annotate_models
  gem 'rails-erd' # , require: false   # generates table diagram run `bundle exec erd`
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'scss_lint', require: false # css linter
  gem 'web-console', '>= 3.3.0'   # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.2'
  gem 'spring'      # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'launchy'                 # open browser with save_and_open_page
  gem 'shoulda-matchers'        # library for easier testing syntax
  gem 'webdrivers'              # to help with testing
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
