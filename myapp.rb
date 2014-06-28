#== ライブラリ ==#
require 'rubygems'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'active_record'
require 'sinatra/activerecord'

#== エスケープ設定 ==#
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

#== データベース環境設定 ==#
# データベース接続
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/dev.db')

# テーブルをクラス化
class Foreigntitle < ActiveRecord::Base
end
class Japanesetitle < ActiveRecord::Base
end

#== 定数 ==#
# 一覧表示するレコードの件数
MAX_TITLES = 18

# ランキング表示するレコードの件数
MAX_RANK = 5

#== Web ==#
# トップ画面
get '/' do
  @page_title = '旧作チェッカー『なりたてQ作』'
  @fr_latest = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a
  @jp_latest = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :hot
end

# 洋画タイトル一覧
get '/foreign' do
  @page_title = '洋画 - 旧作チェッカー『なりたてQ作』'
  @fr_latest = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :foreign
end

# 邦画タイトル一覧
get '/japanese' do
  @page_title = '邦画 - 旧作チェッカー『なりたてQ作』'
  @jp_latest = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :japanese
end

get '/about' do
  @page_title = '本サービスについて - 旧作チェッカー『なりたてQ作』'

  erb :index
end

#== API ==#
# 洋画タイトル一覧
get '/foreign.json' do
  titles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a
  json titles, :content_type => :js, :charset => 'utf-8'
end

# 邦画タイトル一覧
get '/japanese.json' do
  titles = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a
  json titles, :content_type => :js, :charset => 'utf-8'
end

#== 投票機能 ==#
# スキ！
post '/fav/' do
  case params['q']
  when "fr"
    title = Foreigntitle.find(params[:id])
  when "jp"
    title = Japanesetitle.find(params[:id])
  else
    break
  end

  title.favs += 1
  title.save
end

# うーん
post '/boo/' do
  case params['q']
  when "fr"
    title = Foreigntitle.find(params[:id])
  when "jp"
    title = Japanesetitle.find(params[:id])
  else
    break
  end

  title.boos += 1
  title.save
end