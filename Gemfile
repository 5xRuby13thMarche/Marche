source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

gem 'rails', '~> 6.1.7', '>= 6.1.7.3'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'sass-rails', '>= 6'
gem 'webpacker', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem "hotwire-rails", "~> 0.1.3"
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'devise', '~> 4.9', '>= 4.9.2'
gem 'omniauth-google-oauth2', '~> 1.1', '>= 1.1.1'
gem 'omniauth-rails_csrf_protection'
gem 'figaro', '~> 1.1', '>= 1.1.1'
gem "pagy", "~> 6.0"
gem "image_processing", ">= 1.2"
gem "aws-sdk-s3", require: false
gem "ransack", "~> 4.0"
gem "tailwindcss-rails", "~> 2.0"
gem "chartkick", "~> 5.0"
gem "groupdate", "~> 6.2"
gem 'friendly_id', '~> 5.4.0'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "faker", "~> 3.2"
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'listen', '~> 3.3'
  gem "foreman", "~> 0.87.2"
  gem "htmlbeautifier", "~> 1.4"
  # gem 'rack-mini-profiler', '~> 2.0'
  # gem 'spring'
  # Preview email in the default browser instead of sending it
  gem 'letter_opener', '~> 1.4', '>= 1.4.1'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver', '>= 4.0.0.rc1'
  gem 'webdrivers'
end