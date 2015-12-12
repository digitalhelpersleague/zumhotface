source 'https://rails-assets.org/' do
  gem 'rails-assets-lodash'
  gem 'rails-assets-angular', '~> 1.4.0'
  gem 'rails-assets-angular-animate'
  gem 'rails-assets-angular-resource'
  gem 'rails-assets-angular-sanitize'
  gem 'rails-assets-angular-loading-bar'
  gem 'rails-assets-bootstrap-sass-official'
  gem 'rails-assets-moment'
  gem 'rails-assets-angular-moment'
end

source 'https://rubygems.org'

gem 'bundler', '>= 1.7.0'

gem 'rails', '~> 4.0'
gem 'pg'
gem 'paperclip'
gem 'aws-sdk'
gem 'pry-rails'
gem 'grape'
gem 'grape_documenter'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rails'
gem 'resque'
gem 'devise'
gem 'devise_invitable'
gem 'draper'
gem 'gon', github: 'kressh/gon'
gem 'responders'
gem 'gon_responder'

gem 'premailer-rails'
gem 'autoprefixer-rails'

gem 'oj'
gem 'hashie'

gem 'github-linguist', '~> 4.4.2'
gem 'pygments.rb'

gem 'slim-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'rabl-rails'

gem 'foreman'
gem 'dotenv-rails'

group :doc do
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Assets
gem 'jquery-rails'

gem 'ng-rails-csrf'

gem 'rspec-rails', group: [:development, :test]
gem 'rack-ssl-enforcer'

group :production do
  gem 'execjs', platforms: :ruby
  gem 'uglifier', '>= 1.3.0'
  gem 'SyslogLogger'
  gem 'unicorn'
end

group :development do
  gem 'thin'
  gem 'better_errors'
  gem 'binding_of_caller'
  #gem 'rack-mini-profiler'
  gem 'quiet_assets'
  gem 'letter_opener'
end

group :test do
  gem 'faker'
  gem 'factory_girl_rails'
  gem "codeclimate-test-reporter", require: false
  gem 'database_cleaner', require: false
end

# Use debugger
# gem 'debugger', group: [:development, :test]
