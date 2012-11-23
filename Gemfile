source 'http://rubygems.org'

ruby '1.8.7'

gem 'bundler', '~>1.2.0.rc'

gem 'rake', '0.8.7'

# Bundle Rails:
gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'
# gem 'rack', :git => 'git://github.com/rack/rack.git'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'aws-s3', :require => 'aws/s3'

# The sqlite3-ruby gem has changed its name to just sqlite3.
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'sqlite3-ruby', '1.2.5', :require => 'sqlite3'
# gem 'sqlite3-ruby', '>= 1.3.3', :require => 'sqlite3'
gem 'sqlite3', '>= 1.3.6'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end

group :development, :test do
#  gem 'mocha' # Broke testing, somehow.
gem 'mocha', :require => false

# Redgreen 1.2.2 is broken with Ruby 1.9.
gem 'redgreen'

# Slowed testing by three seconds:
#  gem 'autotest-rails'
#  gem 'ZenTest'
end
