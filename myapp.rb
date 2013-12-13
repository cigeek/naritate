# ライブラリ読み込み
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'active_record'
require 'sinatra/activerecord'

# DB接続設定
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/dev.db')

# テーブルをクラス化
class Foreigntitle < ActiveRecord::Base
end
class Japanesetitle < ActiveRecord::Base
end

# 一覧表示するレコードの件数
MAX_TITLES = 18

# ランキング表示するレコードの件数
MAX_RANK = 5

# トップ画面
get '/' do
  @page_title = '旧作チェッカー『なりたてQ作』'

  erb :index
end

# 洋画タイトル一覧
get '/foreign' do
  @page_title = '洋画 - 旧作チェッカー『なりたてQ作』'

  # foreignTitlesテーブルから新しい順にMAX_TITLES件のレコードを取得
  @foreign_titles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).all

  erb :foreign
end

# 邦画タイトル一覧
get '/japanese' do
  @page_title = '邦画 - 旧作チェッカー『なりたてQ作』'

  # japaneseTitlesテーブルから新しい順にMAX_TITLES件のレコードを取得
  @japanese_titles = Japanesetitle.order("created_at desc").limit(MAX_TITLES).all

  erb :japanese
end

# 総合ランキング
get '/ranking' do
  @page_title = '総合ランキング - 旧作チェッカー『なりたてQ作』'

  # foreignTitles、japaneseTitlesテーブルの中で最もfav数の多いレコード5件を取得
  @fav_ranks = ActiveRecord::Base.connection.execute("select * from foreigntitles union select * from japanesetitles order by favs desc, created_at desc limit #{MAX_RANK};")
  # foreignTitles、japaneseTitlesテーブルの中で最もtimes数の多いレコード5件を取得
  @time_ranks = ActiveRecord::Base.connection.execute("select * from foreigntitles union select * from japanesetitles order by times desc, created_at desc limit #{MAX_RANK};")
  
  erb :ranking
end

# 洋画ランキング 
get '/rankingfr' do
  @page_title = '洋画ランキング - 旧作チェッカー『なりたてQ作』'

  # foreignTitlesテーブルの中で最もfav数の多いレコード5件を取得
  @fav_ranks = Foreigntitle.order("favs desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all
  # foreignTitlesテーブルの中で最もtimes数の多いレコード5件を取得
  @time_ranks = Foreigntitle.order("times desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all

  erb :rankingfr
end

# 邦画ランキング
get '/rankingjp' do
  @page_title = '邦画ランキング - 旧作チェッカー『なりたてQ作』'
  
  # foreignTitlesテーブルの中で最もfav数の多いレコード5件を取得
  @fav_ranks = Japanesetitle.order("favs desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all
  # foreignTitlesテーブルの中で最もtimes数の多いレコード5件を取得
  @time_ranks = Japanesetitle.order("times desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all

  erb :rankingjp
end

# favs数のインクリメント処理
post '/fav/:table' do
  # 洋画タイトル一覧からのpostだった場合
  if params[:table] == 'fr'
    title = Foreigntitle.find(params[:id])
    title.favs += 1
    title.save

  # 邦画タイトル一覧からのpostだった場合  
  elsif params[:table] == 'jp'
    title = Japanesetitle.find(params[:id])
    title.favs += 1
    title.save
  end
end

# times数のインクリメント処理
post '/time/:table' do
  # 洋画タイトル一覧からのpostだった場合
  if params[:table] == 'fr'
    title = Foreigntitle.find(params[:id])
    title.times += 1
    title.save

  # 邦画タイトル一覧からのpostだった場合
  elsif params[:table] == 'jp'
    title = Japanesetitle.find(params[:id])
    title.times += 1
    title.save
  end
end