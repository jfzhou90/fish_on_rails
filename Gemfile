# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'bcrypt'
gem 'bootstrap-sass'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.1'
gem 'sass-rails', '~> 5.0'
gem 'slim-rails', '~> 3.2'
gem 'uglifier', '>= 1.3.0'

gem 'turbolinks', '~> 5'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'slim' # for templates

group :development, :test do
  gem 'byebug', '9.0.6', platform: :mri
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen',                '3.1.5'
  gem 'spring',                '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
  gem 'web-console',           '3.5.1'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'chromedriver-helper'
end
