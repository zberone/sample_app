source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'bootstrap-sass', '2.3.2.0'
gem 'bcrypt-ruby', '3.0.1'
gem 'faker', '1.1.2'
gem 'will_paginate', '3.0.4'
gem 'bootstrap-will_paginate', '0.0.9'

group :development, :test do
# Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'rspec-rails', '2.13.1'
#  gem 'guard-rspec', '4.6.0'
#  gem 'spork-rails', '4.0.0'
#  gem 'guard-spork', '2.1.0'
#  gem 'childprocess', '0.6.2'
  gem 'rake', '< 11.0'
#  gem 'rspec-its'
  gem 'mina', group: :development

  gem 'mina-logs', require: false
end

group :test do
	gem 'selenium-webdriver','2.0.0'
	gem 'capybara','2.2.0'
	gem 'zip'
	gem 'test-unit'
  gem 'sprockets', '2.11.0'
  gem 'factory_girl_rails', '4.2.1'
end

# Use SCSS for stylesheets
gem 'sass-rails', '4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '2.1.1'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '4.0.0'
# gem 'execjs'
# gem 'coffee-script-source', '1.8.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails', '2.2.1'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '1.1.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '1.0.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '0.3.20', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

group :production do
  gem 'pg', '0.15.1'
  gem 'rails_12factor', '0.0.2'
  gem 'puma'
    gem 'mina-puma', require: false
end