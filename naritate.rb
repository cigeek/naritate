#== ライブラリ ==#
require 'rubygems'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'amazon/ecs'

#== データベース環境設定 ==#
# データベース接続
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/dev.db')

# テーブルをクラス化
class Foreigntitle < ActiveRecord::Base
end
class Japanesetitle < ActiveRecord::Base
end

# AWS接続設定
Amazon::Ecs.options = {
  :associate_tag => 'cigeek-22',
  :AWS_access_key_id => ENV['AWS_ACCESSKEYID'],
  :AWS_secret_key => ENV['AWS_SECRETKEY']
}

#== Movieクラス ==#
class Movie
  # インスタンスの初期化
  def initialize(title)
    @title = title
    @asin = nil
  end

  # Amazon APIからASINを取得して設定
  def set_asin
    res = Amazon::Ecs.item_search(@title, {
      :search_index => 'DVD',
      :responce_group => 'Small',
      :country => 'jp'
    })

    sleep 10

    if res.items.length > 0
      @asin = res.items.first.get('ASIN')
      return true
    end

    return false
  end

  # DB上に既にタイトルが存在するか判定
  def already_exists?(table)
    res = nil

    if table == 'fr'
      res = Foreigntitle.where(title: @title).first
    elsif table == 'jp'
      res = Japanesetitle.where(title: @title).first
    end

    if res != nil
      return true
    else
      return false
    end
  end

  # インスタンスの情報をDBへ追加
  def add_to(table)
    if table == 'fr'
      Foreigntitle.create(:title => @title, :asin => @asin)
    elsif table == 'jp'
      Japanesetitle.create(:title => @title, :asin => @asin)
    end
  end
end

#== 映画タイトルのスクレイピング ==#
def scrape(target_url, table)
  # ターゲットのHTMLを取得・パース
  charset = nil
  html = open(target_url) do |file|
    charset = file.charset
    file.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)

  # 抽出したタイトル情報に対しての処理
  doc.xpath('//div[@class="productBox"]').each do |el|
    title = el.xpath('span[@class="productText"]/a').text

    if title !~ /Blu\-ray/
      movie = Movie.new(title)
      # DB上にまだ存在しなければ，ASINをセットしてDBに追加
      unless movie.already_exists?(table)
        movie.add_to(table) if movie.set_asin

        puts "#{title} is added"
      end
    end
  end

  puts "Done: #{target_url}"
end
