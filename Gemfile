source 'https://rubygems.org'
ruby '2.1.2'
ENV['NOKOGIRI_USE_SYSTEM_LIBRARIES'] = 'YES'

gem 'sinatra'
gem 'sinatra-contrib'
gem 'rack-cors'
gem 'rake'
gem 'activerecord'
gem 'activesupport', :require => 'activesupport/all'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'nokogiri'
gem 'amazon-ecs'

group :development do
  gem 'sinatra-reloader'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
	gem 'newrelic_rpm'
end
