source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# Use postgres as the database for Active Record
gem 'pg'
gem 'mysql2'
# Use Puma as the app server
gem 'puma', '~> 3.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby
gem 'aws-sdk', '2.10.47'
gem "paperclip", "~> 5.0.0"

#friendship
gem 'has_friendship'

# Use delayed_job
# gem 'delayed_job_active_record'

gem 'rails-assets-sweetalert2', '~> 5.1.1', source: 'https://rails-assets.org'
gem 'sweet-alert2-rails'

# Use SLIM
gem 'slim'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use pry
gem 'pry'
gem 'pry-rails'
gem 'pry-nav'
# Use devise
gem 'devise'
# Use acts_as_votable
gem 'acts_as_votable', '~> 0.10.0'
# Use bootstrap
gem 'bootstrap-sass', '~> 3.2.0'
# Use font awesome
gem 'font-awesome-rails'
# Use autoprefixer It automatically adds the proper vendor prefixes to your CSS code when it is compiled.
gem 'autoprefixer-rails'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
#gem 'bcrypt', '~> 3.1.7'
# Use HTTPARTY
gem 'httparty'
# Use chart js rails
gem 'chart-js-rails'
# Use Swagger-blocks for documentation
gem 'swagger-blocks'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
# Senty for monitoring
gem 'sentry-raven'

gem 'geocoder'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :test do
  # gem 'zelda-formatter'
  # gem 'delorean'
  # gem 'launchy'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'database_cleaner'
  # gem 'cucumber-rails', require: false, github: 'cucumber/cucumber-rails'
  gem 'poltergeist'
  gem 'email_spec'
  gem 'mocha'
  gem 'faker'
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Logging
gem 'timber', '~> 2.4'
