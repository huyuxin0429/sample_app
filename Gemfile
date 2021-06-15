source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3', '>= 6.1.3.2'

# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
 gem 'bcrypt', '~> 3.1.7'

gem 'will_paginate'
gem 'bootstrap-will_paginate'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.4', require: false

gem 'bootstrap-sass', '~> 3.4.1'

#support for pg
gem 'hoe', '~> 3.12'
gem 'hoe-bundler', '~> 1.0'
gem 'hoe-deveiate', '~> 0.9'
gem 'hoe-highline', '~> 0.2'
gem 'hoe-mercurial', '~> 1.4'
gem 'rake-compiler', '~> 1.0'
gem 'rake-compiler-dock', '~> 1.0'
gem 'rdoc', '~> 5.1'
gem 'rspec', '~> 3.5'



#additional validation for active storage
gem 'active_storage_validations', '0.8.2'

# Create fake users
gem "faker"

# Image processing
gem 'image_processing', '1.9.3'
gem 'mini_magick', '4.9.5'

# Access control origin
gem 'rack-cors', :require => 'rack/cors'

# Attempting migration to postgres for development
gem 'pg', '~> 1.2', '>= 1.2.3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # Use sqlite3 as the database for Active Record

  gem 'rails-controller-testing'
  gem 'win32console'

  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
  gem 'guard' # NOTE: this is necessary in newer versions
  gem 'guard-minitest'

  # Attempting migration to postgres for development
  # gem 'sqlite3', '~> 1.4'

  # For API authentication
  gem "jwt"

  
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'spring',      '1.1.3'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'rack-mini-profiler', '~> 2.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'minitest-reporters', '>= 1.4.3'
  gem 'mini_backtrace', '~> 0.1.3'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'

  gem 'database_cleaner-active_record'

  gem "rspec-rails"
  gem "factory_girl_rails"
  gem 'ffaker'
end

group :production do
  gem 'pg', '~> 1.2', '>= 1.2.3'
  #gem 'rails_12factor', '0.0.2'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
