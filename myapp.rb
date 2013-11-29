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
  @pageTitle = 'なりたてQ作 〜映画選びのお供に〜'

  erb :index
end

# 洋画タイトル一覧
get '/foreign' do
  @pageTitle = '洋画 - なりたてQ作 〜映画選びのお供に〜'

  # foreignTitlesテーブルから新しい順にMAX_TITLES件のレコードを取得
  @foreignTitles = Foreigntitle.order("created_at desc").limit(MAX_TITLES).all

  erb :foreign
end

# 邦画タイトル一覧
get '/japanese' do
  @pageTitle = '邦画 - なりたてQ作 〜映画選びのお供に〜'

  # japaneseTitlesテーブルから新しい順にMAX_TITLES件のレコードを取得
  @japaneseTitles = Japanesetitle.order("created_at desc").limit(MAX_TITLES).all

  erb :japanese
end

# 総合ランキング
get '/ranking' do
  @pageTitle = '総合ランキング - なりたてQ作 〜映画選びのお供に〜'

  # foreignTitles、japaneseTitlesテーブルの中で最もfav数の多いレコード5件を取得
  @favrank = ActiveRecord::Base.connection.execute("select * from foreigntitles union select * from japanesetitles order by favs desc, created_at desc limit #{MAX_RANK};")
  # foreignTitles、japaneseTitlesテーブルの中で最もtimes数の多いレコード5件を取得
  @timerank = ActiveRecord::Base.connection.execute("select * from foreigntitles union select * from japanesetitles order by times desc, created_at desc limit #{MAX_RANK};")
  
  erb :ranking
end

# 洋画ランキング 
get '/rankingfr' do
  @pageTitle = '洋画ランキング - なりたてQ作 〜映画選びのお供に〜'

  # foreignTitlesテーブルの中で最もfav数の多いレコード5件を取得
  @favrank = Foreigntitle.order("favs desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all
  # foreignTitlesテーブルの中で最もtimes数の多いレコード5件を取得
  @timerank = Foreigntitle.order("times desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all

  erb :rankingfr
end

# 邦画ランキング
get '/rankingjp' do
  @pageTitle = '邦画ランキング - なりたてQ作 〜映画選びのお供に〜'
  
  # foreignTitlesテーブルの中で最もfav数の多いレコード5件を取得
  @favrank = Japanesetitle.order("favs desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all
  # foreignTitlesテーブルの中で最もtimes数の多いレコード5件を取得
  @timerank = Japanesetitle.order("times desc").limit(MAX_TITLES).order("created_at desc").limit(MAX_RANK).all

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