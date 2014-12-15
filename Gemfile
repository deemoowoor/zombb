source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'bower-rails'

# foreman support for Heroku
gem "foreman"

# Font Awesome gem
gem "font-awesome-rails"

# Bootstrap SASS
gem "bootstrap-sass"

# Theme management
gem "bootswatch-rails"

# Redcarpet Markdown rendering support for post text
gem "redcarpet"

# Authentication
gem "devise"

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Support for AngularJS CSRF
gem 'angular_rails_csrf'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

group :development, :test do
    # Use sqlite3 as the database for Active Record
    gem 'sqlite3'

    # Use debugger
    #gem 'debugger'
end

group :production, :staging do
    # Use PostgreSQL as the database for Active Record
    gem 'pg'
    gem "rails_12factor"
    gem "rails_stdout_logging"
    gem "rails_serve_static_assets"
    # Use unicorn as the app server
    # gem 'unicorn'
end

group :doc do
    # bundle exec rake doc:rails generates the API under doc/api.
    gem 'sdoc', require: false
end

group :test do

    # Rake for Travis CI
    gem 'rake'

    # Codeclimate test reporter
    gem "codeclimate-test-reporter", require: nil

#    gem 'simplecov', require: false
end
