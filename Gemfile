# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.3'

gem 'active_model_serializers', '~> 0.10.2'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.1.3'
gem 'bootstrap_form', '~>4.1.0'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise_invitable', '~>1.7.0'
gem 'friendly_id', '~> 5.2.4'
gem 'haml-rails', '~> 1.0'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'
gem 'redcarpet'
gem 'sass-rails', '~> 5.0'
gem 'sendgrid-ruby'
gem 'simple_form', '~>4.0.1'
gem 'spicy-proton'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
end

group :development do
  gem 'capistrano',         require: false
  gem 'capistrano-rbenv',   require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano3-puma',   require: false

  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rb-readline'
  gem 'rubocop'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  # Gem used to know your params and associations.
  gem 'annotate', git: 'https://github.com/ctran/annotate_models.git'
end

group :test do
  gem 'minitest-rails'
  gem 'minitest-rails-capybara'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'webdrivers', '~> 3.0'
end

group :production, :staging do
  gem 'pg'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
