#== ライブラリ ==#
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require 'sinatra/activerecord'

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

  erb :index
end

# 洋画タイトル一覧
get '/foreign' do
  @page_title = '洋画 - 旧作チェッカー『なりたてQ作』'
  @foreign_titles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :foreign
end

# 邦画タイトル一覧
get '/japanese' do
  @page_title = '邦画 - 旧作チェッカー『なりたてQ作』'
  @japanese_titles = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a

  erb :japanese
end

# 総合ランキング
get '/ranking' do
  @page_title = '総合ランキング - 旧作チェッカー『なりたてQ作』'

  # foreignTitles，japaneseTitlesテーブルの中で最もfav数の多いレコード最新5件を取得
  @fav_ranks = ActiveRecord::Base.connection.execute("select * from foreigntitles union select * from japanesetitles order by favs desc, created_at limit #{MAX_RANK};")
  # foreignTitlesテーブルの中で最もfav数の多いレコード最新5件を取得
  @fr_fav_ranks = Foreigntitle.order("favs desc").limit(MAX_RANK).to_a
  # foreignTitlesテーブルの中で最もfav数の多いレコード最新5件を取得
  @jp_fav_ranks = Japanesetitle.order("favs desc").limit(MAX_RANK).to_a

  erb :ranking
end

#== API ==#
# 洋画タイトル一覧
get '/foreign.json' do
  content_type :json, :charset => 'utf-8'
  titles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).to_a
  titles.to_json(:root => false)
end

# 邦画タイトル一覧
get '/japanese.json' do
  content_type :json, :charset => 'utf-8'
  titles = Japanesetitle.order("created_at desc").limit(MAX_TITLES).to_a
  titles.to_json(:root => false)
end

# 総合ランキング
get '/ranking.json' do
  content_type :json, :charset => 'utf-8'
  titles = ActiveRecord::Base.connection.execute("select * from foreigntitles union select * from japanesetitles order by favs desc, created_at desc limit #{MAX_RANK};")
  titles.to_json(:root => false)
end

# 洋画ランキング
get '/rankingfr.json' do
  content_type :json, :charset => 'utf-8'
  titles = Foreigntitle.order("favs desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).to_a
  titles.to_json(:root => false)
end

# 邦画ランキング
get '/rankingjp.json' do
  content_type :json, :charset => 'utf-8'
  titles = Japanesetitle.order("favs desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).to_a
  titles.to_json(:root => false)
end

#== 投票機能 ==#
# スキ！
# 洋画タイトルの投票処理
post '/fav/fr' do
  title = Foreigntitle.find(params[:id])
  title.favs += 1
  title.save
end

# 邦画タイトルの投票処理
post '/fav/jp' do
  title = Japanesetitle.find(params[:id])
  title.favs += 1
  title.save
end

# うーん
# 洋画タイトルの投票処理
post '/boo/fr' do
  title = Foreigntitle.find(params[:id])
  title.boos += 1
  title.save
end

# 邦画タイトルの投票処理
post '/boo/jp' do
  title = Japanesetitle.find(params[:id])
  title.boos += 1
  title.save
end