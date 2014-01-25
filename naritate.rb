# ライブラリの読み込み
require 'rubygems'
require 'active_record'
require 'open-uri'
require 'nokogiri'
require 'amazon/ecs'

require './ecs'
require './env'

#
# Movieクラス
#
class Movie
  # Movieクラスインスタンスの初期化
  def initialize(title)
    @title = title
    @asin = nil
  end

  # Amazon APIからASINを取得して設定
  def set_asin
    sleep 0.5

    res = Amazon::Ecs.item_search(@title, {
      :search_index => 'DVD',
      :responce_group => 'Small',
      :country => 'jp'}
    )

    if res.items.length > 0 && res.items.first.get('ASIN').length > 8
      @asin = res.items.first.get('ASIN')
    else
      @asin = nil
    end
  end

  # Movieクラスのインスタンスの情報をDBへ追加
  def add_to(table_name)
    if table_name == 'foreigntitles'
      title = Foreigntitle.where(title: @title).first
      if title == nil
        Foreigntitle.create(:title => @title, :asin => @asin)
      end
    elsif table_name == 'japanesetitles'
      title = Japanesetitle.where(title: @title).first
      if title == nil
        Japanesetitle.create(:title => @title, :asin => @asin)
      end
    end
  end

  attr_accessor :title, :asin
end

#
# 映画タイトルのスクレイピング
#
def scrape_info_from(target_url, table_name)
  charset = nil
  html = open(target_url) do |f|
    charset = f.charset
    f.read
  end
  doc = Nokogiri::HTML.parse(html, nil, charset)
  num_titles = 1
  doc.xpath('//div[@class="productBox"]').each do |node|
    title = node.xpath('span[@class="productText"]/a').text
    if title !~ /Blu\-ray/ && num_titles < MAX_TITLES
        movie = Movie.new(title)
        movie.set_asin
        next if movie.asin == nil
        movie.add_to(table_name)
        num_titles += 1
    end
  end
end

# 洋画のタイトルを取得
scrape_info_from("http://posren.livedoor.com/static/corner/old_now.html?id=1", "foreigntitles")
# 邦画のタイトルを取得
scrape_info_from("http://posren.livedoor.com/static/corner/old_now.html?id=3", "japanesetitles")