#== ライブラリ ==#
require 'rubygems'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/reloader' if development?
require 'active_record'
require 'sinatra/activerecord'
require 'rack/cors'

#== ヘルパー ==#
# エスケープ
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
# JSON
helpers Sinatra::JSON

#== データベース環境設定 ==#
# データベース接続
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/db/dev.db')

# テーブルをクラス化
class Foreigntitle < ActiveRecord::Base
end
class Japanesetitle < ActiveRecord::Base
end

# CORS for FxOS Client
use Rack::Cors do
  allow do
    origins '*'
    resource '/api/*',
      :methods => :get,
      :headers => :any,
      :max_age => 0
  end
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
# 人気タイトル
get '/api/hot.json' do
  titles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).where("favs > 0").to_a
  titles += Japanesetitle.order("created_at desc").limit(MAX_TITLES).where("favs > 0").to_a

  json titles
end

# 洋画タイトル一覧
get '/api/foreign.json' do
  titles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a
  json titles
end

# 邦画タイトル一覧
get '/api/japanese.json' do
  titles = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a
  json titles
end

#== 投票機能 ==#
# スキ！
post '/fav/' do
  case params['q']
  when "fr"
    title = Foreigntitle.find(params[:id])
  when "jp"
    title = Japanesetitle.find(params[:id])
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
  end

  title.boos += 1
  title.save
end
