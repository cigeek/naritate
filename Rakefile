require './myapp'
require 'sinatra/activerecord/rake'
require './naritate'

task :refresh do
  # 洋画のタイトルを取得
  scrape("http://posren.com/static/corner/old_now.html?id=1", "fr")
  scrape("http://posren.com/static/corner/old_now.html?id=1&p=2", "fr")
  # 邦画のタイトルを取得
  scrape("http://posren.com/static/corner/old_now.html?id=3", "jp")
  scrape("http://posren.com/static/corner/old_now.html?id=3&p=2", "jp")
end
