require 'rubygems'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'amazon/ecs'
require 'net/http'

# データベース接続
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'sqlite3://localhost/db/dev.db')

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

class Movie
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

    sleep 15 # 規制回避

    if res.items.length > 0
      @asin = res.items.first.get('ASIN')
      return true
    end

    return false
  end

  # DB上に既にタイトルが存在するか判定
  def already_exists?(table)
    res = nil

    case table
    when 'fr'
      res = Foreigntitle.where(title: @title).first
    when 'jp'
      res = Japanesetitle.where(title: @title).first
    end

    res != nil
  end

  # インスタンスの情報をDBへ追加
  def add_to(table)
    case table
    when 'fr'
      Foreigntitle.create(:title => @title, :asin => @asin)
    when 'jp'
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
  cnt = 0
  doc.xpath('//div[@class="productBox"]').each do |el|
    title = el.xpath('span[@class="productText"]/a').text

    if title !~ /Blu\-ray/
      movie = Movie.new(title)
      unless movie.already_exists?(table)
        movie.add_to(table) if movie.set_asin

        puts "#{title} was added"
        cnt += 1
      end
    end
  end

  puts "Done: #{target_url}"
  cnt
end

def send_yo
  res = Net::HTTP.post_form(URI.parse('https://api.justyo.co/yo/'), {
    'api_token' => ENV['YO_TOKEN'],
    'link' => 'http://naritate.kosk.me'
    })

  puts res.body
end

# 洋画の新着情報
new_title = scrape('http://posren.com/static/corner/old_now.html?p=1&id=1', 'fr')
new_title += scrape('http://posren.com/static/corner/old_now.html?p=2&id=1', 'fr')
# 邦画の新着情報
new_title += scrape('http://posren.com/static/corner/old_now.html?p=1&id=3', 'jp')
new_title += scrape('http://posren.com/static/corner/old_now.html?p=2&id=3', 'jp')

send_yo if new_title > 0