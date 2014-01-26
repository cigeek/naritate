#== ライブラリ ==#
require 'rubygems'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'amazon/ecs'

#== 環境設定 ==#
require './env'
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
    @asin = self.set_asin
  end

  # Amazon APIからASINを取得して設定
  def set_asin
    sleep 0.5

    res = Amazon::Ecs.item_search(@title, {
      :search_index => 'DVD',
      :responce_group => 'Small',
      :country => 'jp'
    })

    if res.items.length > 0
      @asin = res.items.first.get('ASIN')
    else
      @asin = nil
    end
  end

  # インスタンスの情報(ASIN)が有効かどうか判定
  def valid?
    if @asin.length > 8 && @asin != nil
      return true
    else
      return false
    end
  end

  # DB上に既にタイトルが存在するか判定 
  def exist_in?(table)
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
    if table == 'fr' && !(self.exist_in?('fr'))
      Foreigntitle.create(:title => @title, :asin => @asin)
    elsif table == 'jp' && !(self.exist_in?('jp'))
      Japanesetitle.create(:title => @title, :asin => @asin)
    end
  end
end

#== 映画タイトルのスクレイピング ==#
def scrape(target_url, table)
  charset = nil
  html = open(target_url) do |file|
    charset = file.charset
    file.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)

  count = 1
  doc.xpath('//div[@class="productBox"]').each do |el|
    title = el.xpath('span[@class="productText"]/a').text
    if title !~ /Blu\-ray/ && count < MAX_TITLES
      movie = Movie.new(title)
      if movie.valid?
        movie.add_to(table)
        count += 1
      end
    end
  end
end

# 洋画のタイトルを取得
scrape("http://posren.livedoor.com/static/corner/old_now.html?id=1", "fr")
# 邦画のタイトルを取得
scrape("http://posren.livedoor.com/static/corner/old_now.html?id=3", "jp")